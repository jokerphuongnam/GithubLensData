import Foundation

public protocol GithubAFRequest: AFRequest { }

public extension GithubAFRequest {
    var baseURL: URL {
        URL(string: "https://api.github.com/")!
    }
}
