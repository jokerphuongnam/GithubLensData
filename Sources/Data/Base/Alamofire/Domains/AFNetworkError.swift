public struct AFResponseError: Decodable, Sendable {
    let statusCode: Int?
    let status: Bool?
    let message: String?

    public init(_ status: Bool, statusCode: Int? = nil) {
        self.status = status
        self.statusCode = statusCode
        message = nil
    }

    public init(_ message: String, statusCode: Int? = nil) {
        self.message = message
        self.statusCode = statusCode
        status = nil
    }
    
    public init(status: Bool, message: String, statusCode: Int? = nil) {
        self.status = status
        self.message = message
        self.statusCode = statusCode
    }
}

extension AFResponseError: Equatable {
    public static func == (lhs: AFResponseError, rhs: AFResponseError) -> Bool {
        return lhs.status == rhs.status && lhs.message == rhs.message
    }
}

public enum AFNetworkError: Error {
    case connectionFailed(Error)
    case serverError
    case maintenance
    case otherError(AFResponseError)
    case unknownError(AFResponseError)
    case dataNotExist
    case statusCodeNotExist
    case timeout
    case noConnection
    case expired
    case notFound

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
        }
    }
}

extension AFNetworkError: Equatable {
    public static func == (lhs: AFNetworkError, rhs: AFNetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.connectionFailed(_), .connectionFailed(_)):
            return true
        case (.serverError, .serverError):
            return true
        case (.maintenance, .maintenance):
            return true
        case (.otherError(let a), .otherError(let b)):
            return a == b
        case (.unknownError(let a), .unknownError(let b)):
            return a == b
        case (.dataNotExist, .dataNotExist):
            return true
        case (.statusCodeNotExist, .statusCodeNotExist):
            return true
        case (.notFound, .notFound):
            return true
        case (.timeout, .timeout):
            return true
        default:
            return false
        }
    }
}
