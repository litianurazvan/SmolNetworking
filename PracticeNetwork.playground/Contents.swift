import SmolNetwork
import PlaygroundSupport
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

    public var requestType: RequestType { .data }

    public var responseType: ResponseType { .json }
}

/// Environments enum.
public enum Environment {
    /// The development environment.
    case development
    /// The production environment.
    case production
}

extension Environment : EnvironmentProtocol {
    /// The base URL of the given environment.
    public var baseURL: String {
        switch self {
        case .development:
            return "https://jsonplaceholder.typicode.com"
        case .production:
            return "https://api.yourapp.com/v1/"
        }
    }
}

let requestDispatcher = APIRequestDispatcher(
    environment: Environment.development,
    networkSession: APINetworkSession()
)

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

let todoRequest = TodoEndpoint.todo(identifier: 1)
let all = TodoEndpoint.all

let todoOperation = APIOperation<[Todo]>(all)
todoOperation.execute(in: requestDispatcher) { result in
  // Handle result
    DispatchQueue.main.async {
        print(result)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
