import Foundation

/// The expected remote response type.
public enum ResponseType {
    /// Used when the expected response is a JSON payload.
    case json
    /// Used when the expected response is a file.
    case file
}
