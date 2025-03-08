import Foundation

// Defines a protocol for Github-specific requests by extending AFRequest.
// This protocol doesn't add any new requirements, but serves as a marker
// and allows us to provide default implementations specific to Github.
protocol GithubAFRequest: AFRequest { }

// An extension on GithubAFRequest to provide a default implementation for baseURL.
// This ensures that any type conforming to GithubAFRequest will use the Github API base URL.
extension GithubAFRequest {
    // The base URL for all Github API requests.
    // The forced unwrap (!) is used here because the URL string is a known valid URL.
    var baseURL: URL {
        URL(string: "https://api.github.com/")!
    }
}
