import Alamofire

public protocol AFResponse: Decodable & Hashable & Sendable {
    var request: DataRequest! { get set }
    var statusCode: Int! { get set }
}
