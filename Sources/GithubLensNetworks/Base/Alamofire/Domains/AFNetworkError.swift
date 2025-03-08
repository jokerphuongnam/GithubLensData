// Represents an error response from the network call. It conforms to Decodable and Sendable
// so it can be easily decoded from JSON and safely used in concurrent contexts.
public struct AFResponseError: Decodable, Sendable {
    // Optional HTTP status code returned from the server.
    public let statusCode: Int?
    // Optional Boolean representing a status flag (could be used to indicate success/failure).
    public let status: Bool?
    // Optional error message that provides additional details.
    public let message: String?

    // Initializer when you want to create an error with a status value and possibly a status code.
    // In this case, no message is provided.
    public init(_ status: Bool, statusCode: Int? = nil) {
        self.status = status
        self.statusCode = statusCode
        message = nil
    }

    // Initializer when you want to create an error with a message and possibly a status code.
    // Here, the status value is set to nil.
    public init(_ message: String, statusCode: Int? = nil) {
        self.message = message
        self.statusCode = statusCode
        status = nil
    }
    
    // Initializer when both a status and a message are available, along with an optional status code.
    public init(status: Bool, message: String, statusCode: Int? = nil) {
        self.status = status
        self.message = message
        self.statusCode = statusCode
    }
}

// Make AFResponseError conform to Equatable to enable easy comparison.
// Two AFResponseErrors are considered equal if their status and message are equal.
extension AFResponseError: Equatable {
    public static func == (lhs: AFResponseError, rhs: AFResponseError) -> Bool {
        return lhs.status == rhs.status && lhs.message == rhs.message
    }
}

// Represents various types of network errors that can occur.
// This enum conforms to the Error protocol so it can be thrown.
public enum AFNetworkError: Error {
    // Represents an error when a connection fails, encapsulating the underlying error.
    case connectionFailed(Error)
    // Represents a server-side error (e.g., HTTP status 500).
    case serverError
    // Indicates that the service is under maintenance.
    case maintenance
    // Wraps an error response with additional information.
    case otherError(AFResponseError)
    // Wraps an unknown error with additional details.
    case unknownError(AFResponseError)
    // Indicates that the expected data is missing in the response.
    case dataNotExist
    // Indicates that the HTTP status code is missing.
    case statusCodeNotExist
    // Indicates that the request timed out.
    case timeout
    // Indicates that there is no network connection.
    case noConnection
    // Indicates that the session or token has expired.
    case expired
    // Represents a 404 Not Found error.
    case notFound
    // Represents a 403 Forbidden error.
    case forbidden

    // This method returns a Decodable instance from the error, if applicable.
    // In most cases, only 'otherError' and 'unknownError' contain associated AFResponseError data.
    func responseDecode() -> Decodable? {
        switch self {
        case .connectionFailed(_):
            return nil
        case .serverError:
            return nil
        case .maintenance:
            return nil
        case .otherError(let data):
            return data
        case .unknownError(let data):
            return data
        case .dataNotExist:
            return nil
        case .statusCodeNotExist:
            return nil
        case .timeout:
            return nil
        case .noConnection:
            return nil
        case .expired:
            return nil
        case .notFound:
            return nil
        case .forbidden:
            return nil
        }
    }
}

// Make AFNetworkError conform to Equatable so that errors can be compared.
extension AFNetworkError: Equatable {
    public static func == (lhs: AFNetworkError, rhs: AFNetworkError) -> Bool {
        switch (lhs, rhs) {
        // For connectionFailed, consider them equal regardless of the underlying error details.
        case (.connectionFailed(_), .connectionFailed(_)):
            return true
        case (.serverError, .serverError):
            return true
        case (.maintenance, .maintenance):
            return true
        // For errors that wrap AFResponseError, compare the underlying AFResponseError values.
        case (.otherError(let a), .otherError(let b)):
            return a == b
        case (.unknownError(let a), .unknownError(let b)):
            return a == b
        // For errors with no associated data, if the case is the same, they are equal.
        case (.dataNotExist, .dataNotExist):
            return true
        case (.statusCodeNotExist, .statusCodeNotExist):
            return true
        case (.notFound, .notFound):
            return true
        case (.timeout, .timeout):
            return true
        case (.forbidden, .forbidden):
            return true
        // Any mismatching cases are considered not equal.
        default:
            return false
        }
    }
}
