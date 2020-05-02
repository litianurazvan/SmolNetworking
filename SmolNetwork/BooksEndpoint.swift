import Foundation

/// Books endpoint
public enum BooksEndpoint {
    /// Lists all the books.
    case index
    /// Fetches a book with a given identifier.
    case get(identifier: String)
    /// Creates a book with the given parameters.
    case create(parameters: [String: Any?])
}

extension BooksEndpoint: RequestProtocol {
    public var path: String {
        switch self {
        case .index:
            return "/books"
        case .get(let identifier):
            return "/books/\(identifier)"
        case .create(_):
            return "/books"
        }
    }

    public var method: RequestMethod {
        switch self {
        case .index:
            return .get
        case .get:
            return .get
        case .create:
            return .post
        }
    }

    public var parameters: RequestParameters? {
        switch self {
        case .index:
            return nil
        case .get:
            return nil
        case .create(let parameters):
            return parameters
        }
    }

    public var requestType: RequestType {
        return .data
    }

    public var responseType: ResponseType {
        return .json
    }
}
