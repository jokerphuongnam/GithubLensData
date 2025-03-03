import Testing
import Foundation
import Alamofire
@testable import GithubLensNetworks

@Suite("Real Url")
private struct RealUrlBaseAsyncTests {
    private let sut: AsyncAFNetwork
    
    init() {
        sut = TestAsyncAFNetwork(session: Session.default, decoder: JSONDecoder())
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
            _ = try await sut.send(request: request)
            
            // then
            #expect(true)
        }
    }
}
