import Foundation

/// The request type that matches the URLSessionTask types.
public enum RequestType {
    /// Will translate to a URLSessionDataTask.
    case data
    /// Will translate to a URLSessionDownloadTask.
    case download
    /// Will translate to a URLSessionUploadTask.
    case upload
}
