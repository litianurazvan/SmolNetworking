import Foundation

/// Environments enum.
public enum Environment {
    /// The development environment.
    case development
    /// The production environment.
    case production
}

extension Environment : EnvironmentProtocol {
    /// The default HTTP request headers for the given environment.
    public var headers: RequestHeaders? {
        switch self {
        case .development:
            return [:]
        case .production:
            return [:]
        }
    }
    
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
