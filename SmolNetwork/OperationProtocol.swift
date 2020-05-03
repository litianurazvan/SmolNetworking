import Foundation

/// The type to which all operations must conform in order to execute and cancel a request.
internal protocol OperationProtocol {
    associatedtype Output: Decodable

    /// The request to be executed.
    var request: RequestProtocol { get }

    /// Execute a request using a request dispatcher.
    /// - Parameters:
    ///   - requestDispatcher: `RequestDispatcherProtocol` object that will execute the request.
    ///   - completion: Completion block.
    func execute(in requestDispatcher: APIRequestDispatcher, completion: @escaping (OperationResult<Output>) -> Void) ->  Void

    /// Cancel the operation.
    func cancel() -> Void
}




