import Foundation


/// Class that handles the dispatch of requests to an environment with a given configuration.
public final class APIRequestDispatcher {
    
    /// The environment configuration.
    private var environment: EnvironmentProtocol
    
    /// The network session configuration.
    private var networkSession: NetworkSessionProtocol
    
    /// Required initializer.
    /// - Parameters:
    ///   - environment: Instance conforming to `EnvironmentProtocol` used to determine on which environment the requests will be executed.
    ///   - networkSession: Instance conforming to `NetworkSessionProtocol` used for executing requests with a specific configuration.
    required public init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
        self.environment = environment
        self.networkSession = networkSession
    }
    
    /// Executes a request.
    /// - Parameters:
    ///   - request: Instance conforming to `RequestProtocol`
    ///   - completion: Completion handler.
    public func execute<Output>(_ output: Output.Type, request: RequestProtocol, completion: @escaping (OperationResult<Output>) -> Void) -> URLSessionTask? {
        // Create a URL request.
        guard var urlRequest = request.urlRequest(with: environment) else {
            completion(.error(APIError.badRequest("Invalid URL for: \(request)"), nil))
            return nil
        }
        // Add the environment specific headers.
        environment.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        
        // Create a URLSessionTask to execute the URLRequest.
        var task: URLSessionTask?
        switch request.requestType {
        case .data:
            task = networkSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
                guard let self = self else { return }
                self.handleJsonTaskResponse(output, data: data, urlResponse: urlResponse, error: error) { completion(self.bridge($0)) }
            })
        case .download:
            task = networkSession.downloadTask(request: urlRequest, progressHandler: request.progressHandler, completionHandler: { [weak self] (fileUrl, urlResponse, error) in
                self?.handleFileTaskResponse(fileUrl: fileUrl, urlResponse: urlResponse, error: error, completion: completion as! (OperationResult<URL>) -> Void)
            })
        case .upload:
            task = networkSession.uploadTask(with: urlRequest, from: URL(fileURLWithPath: ""), progressHandler: request.progressHandler, completion: { [weak self] (data, urlResponse, error) in
                guard let self = self else { return }
                self.handleJsonTaskResponse(output, data: data, urlResponse: urlResponse, error: error) { completion(self.bridge($0)) }
            })
        }
        // Start the task.
        task?.resume()
        
        return task
    }
    
    
    private func bridge<T>(_ result: (Result<T, Error>)) -> (OperationResult<T>) {
        switch result {
        case let .success(response):
            return .json(response, nil)
        case let .failure(error):
            return .error(error, nil)
        }
    }
    
    /// Handles the data response that is expected as a JSON object output.
    /// - Parameters:
    ///   - data: The `Data` instance to be serialized into a JSON object.
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    ///   - completion: Completion handler.
    private func handleJsonTaskResponse<T: Decodable>(_ type: T.Type, data: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        // Check if the response is valid.
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        
        guard let data = data else {
            completion(.failure(APIError.noData))
            return
        }
        
        
        // Verify the HTTP status code.
        completion(
            verify(data: data, urlResponse: urlResponse, error: error)
                .flatMap { data in
                    Result(catching: { try JSONDecoder().decode(type, from: data) })
            }
        )
    }
    
    /// Handles the url response that is expected as a file saved ad the given URL.
    /// - Parameters:
    ///   - fileUrl: The `URL` where the file has been downloaded.
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    ///   - completion: Completion handler.
    private func handleFileTaskResponse(fileUrl: URL?, urlResponse: URLResponse?, error: Error?, completion: @escaping (OperationResult<URL>) -> Void) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            completion(OperationResult.error(APIError.invalidResponse, nil))
            return
        }
        
        let result = verify(data: fileUrl, urlResponse: urlResponse, error: error)
        switch result {
        case .success(let url):
            completion(.file(url, urlResponse))
            
        case .failure(let error):
            completion(.error(error, urlResponse))
        }
    }
    
    /// Checks if the HTTP status code is valid and returns an error otherwise.
    /// - Parameters:
    ///   - data: The data or file  URL .
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    /// - Returns: A `Result` instance.
    private func verify<T>(data: T, urlResponse: HTTPURLResponse, error: Error?) -> Result<T, Error> {
        switch urlResponse.statusCode {
        case 200...299:
            return .success(data)
        case 400...499:
            return .failure(APIError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(APIError.serverError(error?.localizedDescription))
        default:
            return .failure(APIError.unknown)
        }
    }
}

