import Alamofire
import Foundation

public protocol AFRequest where Self.Response: AFResponse {
    associatedtype Response
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL { get }
    var parameters: Parameters { get }
    var httpHeaderFields: HTTPHeaders { get }
    var encoding: URLEncoding { get }
    var interceptor: RequestInterceptor? { get }
}

public extension AFRequest {
    var encoding: URLEncoding {
        .default
    }
    
    var httpHeaderFields: HTTPHeaders {
        [:]
    }
    
    var parameters: Parameters {
        [:]
    }
    
    var interceptor: RequestInterceptor? {
        nil
    }
    
    var url: URL {
        if path.isEmpty {
            return baseURL
        }
        return baseURL.appendingPathComponent(path)
    }
    
    var method: HTTPMethod {
        .get
    }
}
