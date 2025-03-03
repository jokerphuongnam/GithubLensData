import Testing
import Foundation
import Alamofire
@testable import GithubLensNetworks

@Suite("Real Url")
private struct RealUrlBaseAsyncTests {
    private let sut: AsyncAFNetwork
    private let session: Session
    private let decoder: JSONDecoder
    
    init() {
        sut = TestAsyncAFNetwork()
        session = .default
        decoder = JSONDecoder()
    }
    
    @Test(
        "Ping to real url",
        arguments: [
            "https://api.github.com/users?per_page=0&since=20",
            "https://api.github.com/users/BrianTheCoder"
        ]
    )
    func pingRealURLs(link: String) async {
        // given
        let url = URL(string: link)!
        let request = PingRequest(baseURL: url, path: "")
        
        await #expect(throws: Never.self) {
            // when
            _ = try await sut.send(session: session, decoder: decoder, request: request)
            
            // then
            #expect(true)
        }
    }
}
