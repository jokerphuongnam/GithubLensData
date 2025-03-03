@testable import Data

struct ErrorMock {
    let statusCode: Int
    let error: AFNetworkError
    
    static let mocks: [Self] = [
        .init(
            statusCode: 404,
            error: AFNetworkError.notFound
        ),
        .init(
            statusCode: 500,
            error: AFNetworkError.serverError
        ),
        .init(
            statusCode: 503,
            error: AFNetworkError.serverError
        )
    ]
}
