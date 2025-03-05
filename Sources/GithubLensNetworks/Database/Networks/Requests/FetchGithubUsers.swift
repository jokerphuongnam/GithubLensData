import Alamofire

struct FetchGithubUsersRequest: GithubAFRequest {
    typealias Response = [FetchGithubUsersResponse]
    var path: String = "users"
    var parameters: Parameters
    var encoding: URLEncoding = .queryString
    var httpHeaderFields: HTTPHeaders = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    init(perPage: Int, since: Int) {
        parameters = [
            "per_page": perPage,
            "since": since
        ]
    }
}

public struct FetchGithubUsersResponse: AFResponse {
    public let login: String
    public let avatarURL: String
    public let htmlURL: String
    
    init(login: String, avatarURL: String, htmlURL: String) {
        self.login = login
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
    }
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
