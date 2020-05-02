import Foundation

/// Type alias used for HTTP request headers.
public typealias RequestHeaders = [String: String]

/// Type alias used for HTTP request parameters. Used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
public typealias RequestParameters = [String : Any?]

/// Type alias used for the HTTP request download/upload progress.
public typealias ProgressHandler = (Double) -> Void
