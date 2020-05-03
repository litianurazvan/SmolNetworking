import Foundation

/// Todos endpoint
public enum TodoEndpoint {
    /// Lists all the Todos.
    case all
    /// Fetches a todo with a given identifier.
    case todo(identifier: Int)
}

extension TodoEndpoint: RequestProtocol {
    public var path: String {
        switch self {
        case .all:
            return "/todos"
        case .todo(let identifier):
            return "/todos/\(identifier)"
        }
    }

    public var method: RequestMethod {
        switch self {
        case .all:
            return .get
        case .todo:
            return .get
        }
    }

    public var parameters: RequestParameters? {
        switch self {
        case .all:
            return nil
        case .todo:
            return nil
        }
    }

    public var requestType: RequestType {
        return .data
    }

    public var responseType: ResponseType {
        return .json
    }
}
