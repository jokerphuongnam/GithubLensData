import Foundation
import Alamofire

public protocol GithubNetwork {
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse]
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse
}

struct GithubNetworkImpl: GithubNetwork, AsyncAFNetwork {
    private let session: Session
    private let decoder: JSONDecoder
    
    init(session: Session, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
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
