import Foundation

/// The expected result of an API Operation.
public enum OperationResult<Response: Decodable> {
    /// JSON reponse.
    case json(_ : Response, _ : HTTPURLResponse?)
    /// A downloaded file with an URL.
    case file(_ : URL?, _ : HTTPURLResponse?)
    /// An error.
    case error(_ : Error?, _ : HTTPURLResponse?)
}
