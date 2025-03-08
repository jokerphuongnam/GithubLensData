import Alamofire

// A request struct for fetching Github user details.
// It conforms to GithubAFRequest (assumed to be a protocol extending AFRequest tailored for Github).
struct FetchGithubUserDetailsRequest: GithubAFRequest {
    // Specify the expected response type for this request.
    public typealias Response = FetchGithubUserDetailsResponse

    // Base path component for the Github API endpoint related to users.
    let _path: String = "users"
    
    // The username of the Github account to fetch details for.
    let loginUsername: String
    
    // Computes the full path for the request by appending the username
    // to the base path. For example, "users/johndoe".
    var path: String {
        return "\(_path)/\(loginUsername)"
    }
    
    // HTTP header fields for the request.
    // Here we specify the content type as JSON with UTF-8 charset.
    var httpHeaderFields: HTTPHeaders = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    // Initializer for the request, which takes a loginUsername parameter.
    init(loginUsername: String) {
        self.loginUsername = loginUsername
    }
}

// A response struct for decoding the Github user details.
// It conforms to AFResponse (which is a typealias for Decodable & Hashable & Sendable).
public struct FetchGithubUserDetailsResponse: AFResponse {
    // Properties mapping the expected JSON keys from the Github API.
    public let login: String
    public let avatarUrl: String
    public let htmlUrl: String
    public let location: String?
    public let followers: Int?
    public let following: Int?
    
    // Custom initializer to set up all properties.
    init(login: String, avatarUrl: String, htmlUrl: String, location: String?, followers: Int?, following: Int?) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.location = location
        self.followers = followers
        self.following = following
    }
    
    // CodingKeys enum to map JSON keys to the struct's properties.
    // This is necessary when the JSON keys differ from the property names.
    enum CodingKeys: String, CodingKey {
        case login
        // The JSON key "avatar_url" maps to the property "avatarUrl".
        case avatarUrl = "avatar_url"
        // The JSON key "html_url" maps to the property "htmlUrl".
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
}
