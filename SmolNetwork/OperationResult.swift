import Foundation

/// The expected result of an API Operation.
public enum OperationResult {
    /// JSON reponse.
    case json(_ : Any?, _ : HTTPURLResponse?)
    /// A downloaded file with an URL.
    case file(_ : URL?, _ : HTTPURLResponse?)
    /// An error.
    case error(_ : Error?, _ : HTTPURLResponse?)
}
