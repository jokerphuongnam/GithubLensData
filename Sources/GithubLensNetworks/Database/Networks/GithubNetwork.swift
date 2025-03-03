import Foundation
import Alamofire

public protocol GithubNetwork {
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse]
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse
}

struct GithubNetworkImpl: GithubNetwork {
    private let asyncNetwork: AsyncAFNetwork
    
    init(session: Session, decoder: JSONDecoder) {
        self.asyncNetwork = AsyncAFNetwork(session: session, decoder: decoder)
    }
    
    func fetchGithubUser(perPage: Int, since: Int) async throws -> [FetchGithubUsersResponse] {
        try await asyncNetwork.send(
            request: FetchGithubUsersRequest(
                perPage: perPage,
                since: since
            )
        )
    }
    
    func fetchGithubUserDetails(loginUsername: String) async throws -> FetchGithubUserDetailsResponse {
        try await asyncNetwork.send(
            request: FetchGithubUserDetailsRequest(
                loginUsername: loginUsername
            )
        )
    }
}
