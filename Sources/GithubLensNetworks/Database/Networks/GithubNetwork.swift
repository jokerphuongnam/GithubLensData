import Foundation
import Alamofire

// MARK: - GithubNetwork Protocol
// This protocol defines the abstraction for a network layer that interacts with the Github API.
// It includes functions to fetch a list of Github users and to fetch details for a specific user.
public protocol GithubNetwork {
    // Fetch a list of Github users using pagination.
    // - perPage: The number of users to fetch per request.
    // - since: An integer representing the starting point for fetching users.
    // Returns an array of FetchGithubUsersResponse objects.
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse]
    
    // Fetch detailed information for a specific Github user.
    // - loginUsername: The login username of the Github user.
    // Returns a FetchGithubUserDetailsResponse object.
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse
}

// MARK: - GithubNetworkImpl Implementation
// This struct provides a concrete implementation of the GithubNetwork protocol,
// and it also conforms to AsyncAFNetwork (presumably providing the 'send' function to perform requests).
struct GithubNetworkImpl: GithubNetwork, AsyncAFNetwork {
    // Private properties to hold the Alamofire session and JSON decoder.
    private let session: Session
    private let decoder: JSONDecoder
    
    // Dependency injection of session and decoder for flexibility and testability.
    init(session: Session, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    // Implements fetching a list of Github users.
    // It constructs a FetchGithubUsersRequest with the provided parameters and sends it using the 'send' function.
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse] {
        try await send(
            session: session,
            decoder: decoder,
            request: FetchGithubUsersRequest(
                perPage: perPage,
                since: since
            )
        )
    }
    
    // Implements fetching detailed information for a specific Github user.
    // It creates a FetchGithubUserDetailsRequest using the loginUsername and sends it using the 'send' function.
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse {
        try await send(
            session: session,
            decoder: decoder,
            request: FetchGithubUserDetailsRequest(
                loginUsername: loginUsername
            )
        )
    }
}
