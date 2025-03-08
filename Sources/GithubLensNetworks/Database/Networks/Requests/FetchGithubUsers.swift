import Alamofire

// Defines a request for fetching multiple Github users.
// Conforms to GithubAFRequest, which is assumed to extend AFRequest for Github-specific endpoints.
struct FetchGithubUsersRequest: GithubAFRequest {
    // The expected response is an array of FetchGithubUsersResponse objects.
    typealias Response = [FetchGithubUsersResponse]
    
    // The API endpoint path for fetching users.
    var path: String = "users"
    
    // Query parameters for the request.
    // These will be appended to the URL as query items.
    var parameters: Parameters
    
    // Specifies that the parameters should be encoded into the URL's query string.
    var encoding: URLEncoding = .queryString
    
    // HTTP headers for the request.
    // Here, the Content-Type header is set to indicate JSON data.
    var httpHeaderFields: HTTPHeaders = [
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    // Custom initializer to create a request with pagination parameters.
    // - perPage: Number of users to fetch per page.
    // - since: Fetch users starting from this user ID.
    init(perPage: Int, since: Int) {
        parameters = [
            "per_page": perPage,
            "since": since
        ]
    }
}

// Represents the response for a Github user in the list.
// Conforms to AFResponse, which is a typealias combining Decodable, Hashable, and Sendable.
public struct FetchGithubUsersResponse: AFResponse {
    // The user's login name.
    public let login: String
    // URL for the user's avatar image.
    public let avatarURL: String
    // URL to the user's profile page.
    public let htmlURL: String
    
    // Custom initializer to set up the properties.
    init(login: String, avatarURL: String, htmlURL: String) {
        self.login = login
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
    }
    
    // Maps the JSON keys from the Github API to the struct's properties.
    enum CodingKeys: String, CodingKey {
        case login
        // Maps the JSON key "avatar_url" to the property "avatarURL".
        case avatarURL = "avatar_url"
        // Maps the JSON key "html_url" to the property "htmlURL".
        case htmlURL = "html_url"
    }
}
