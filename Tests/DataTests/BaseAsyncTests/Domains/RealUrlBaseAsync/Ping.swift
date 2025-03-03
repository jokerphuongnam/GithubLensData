import Foundation
import Alamofire
@testable import Data

struct PingRequest: AFRequest {
    typealias Response = PingResponse
    
    var baseURL: URL
    var path: String

    init(baseURL: URL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }

    public func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.head.rawValue
        return request
    }
}

struct PingResponse: AFResponse {
    var request: DataRequest!
    var statusCode: Int!
    
    init(from decoder: any Decoder) throws { }
    
    enum CodingKeys: CodingKey { }
}
