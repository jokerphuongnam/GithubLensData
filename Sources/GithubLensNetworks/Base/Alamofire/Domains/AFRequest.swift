import Alamofire
import Foundation

// MARK: - Request
// Defines a protocol for network requests using Alamofire.
// Any type conforming to AFRequest must specify a Response type that adheres to AFResponse.
protocol AFRequest where Self.Response: AFResponse {
    // Associated type representing the expected response from the request.
    associatedtype Response
    
    // Base URL of the API endpoint.
    var baseURL: URL { get }
    // HTTP method (GET, POST, etc.) used for the request.
    var method: HTTPMethod { get }
    // Specific endpoint path to be appended to the baseURL.
    var path: String { get }
    // The complete URL for the request, combining baseURL and path.
    var url: URL { get }
    // Query or body parameters for the request.
    var parameters: Parameters { get }
    // HTTP header fields for the request.
    var httpHeaderFields: HTTPHeaders { get }
    // Encoding strategy for the parameters (e.g., URL or JSON encoding).
    var encoding: URLEncoding { get }
    // An optional interceptor that can handle request adaptation, retrying, etc.
    var interceptor: RequestInterceptor? { get }
}

// MARK: - Default for request
// Provides default implementations for some properties in the AFRequest protocol,
// reducing boilerplate for conforming types.
extension AFRequest {
    // Default encoding is URL encoding.
    var encoding: URLEncoding {
        .default
    }
    
    // By default, there are no additional HTTP header fields.
    var httpHeaderFields: HTTPHeaders {
        [:]
    }
    
    // By default, no parameters are included.
    var parameters: Parameters {
        [:]
    }
    
    // No request interceptor is used by default.
    var interceptor: RequestInterceptor? {
        nil
    }
    
    // Computes the full URL by appending the path to the base URL.
    // If the path is empty, it simply returns the base URL.
    var url: URL {
        if path.isEmpty {
            return baseURL
        }
        return baseURL.appendingPathComponent(path)
    }
    
    // Default HTTP method is GET.
    var method: HTTPMethod {
        .get
    }
}
