import Alamofire

struct FetchGithubUserDetailsRequest: GithubAFRequest {
    public typealias Response = FetchGithubUserDetailsResponse
    
    let _path: String = "users"
    let loginUsername: String
    var path: String {
        return "\(_path)/\(loginUsername)"
    }
    var httpHeaderFields: HTTPHeaders = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    init(loginUsername: String) {
        self.loginUsername = loginUsername
    }
}

public struct FetchGithubUserDetailsResponse: AFResponse {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
}
