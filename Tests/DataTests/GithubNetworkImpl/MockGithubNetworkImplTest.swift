import Testing
import Foundation
import Alamofire
import Mocker
@testable import Data

@Suite("Mock Github users tests")
struct MockGithubNetworkImplTest {
    private let sut: GithubNetworkImpl
    
    init() {
        // Configure a URLSession that uses our MockURLProtocol.
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let session = Alamofire.Session(configuration: configuration)
        
        let decoder = JSONDecoder()
        self.sut = GithubNetworkImpl(session: session, decoder: decoder)
    }
    
    @Test(
        "Fetch users success",
        arguments: MockFetchUsersSuccess.mocks
    ) func fetchUsersSuccess(
        mockUsers: MockFetchUsersSuccess
    ) async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users?per_page=\(mockUsers.count)&since=0")!,
            contentType: .json,
            statusCode: 202,
            data: [
                .get: mockUsers.mockJSON.data(using: .utf8)!
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(2)
        mock.register()
        
        await #expect(throws: Never.self) {
            // when
            let users = try await sut.fetchGithubUser(perPage: mockUsers.count, since: 0)
            
            // then
            #expect(users.count == mockUsers.count)
            #expect(users.first?.login == mockUsers.login)
        }
    }
    
    @Test(
        "Fetch users error",
        arguments: ErrorMock.mocks
    )
    func fetchUsersError(mockError: ErrorMock) async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users?per_page=\(mockError.statusCode)&since=0")!,
            contentType: .json,
            statusCode: mockError.statusCode,
            data: [
                .get: Data()
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(1)
        mock.register()
        
        await #expect(throws: mockError.error) {
            // when
            _ = try await sut.fetchGithubUser(perPage: mockError.statusCode, since: 0)
        }
    }
    
    @Test("Fetch users timeout")
    func fetchUsersTimeOut() async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users?per_page=0&since=0")!,
            contentType: .json,
            statusCode: 202,
            data: [
                .get: Data()
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(12)
        mock.register()
        
        await #expect(throws: AFNetworkError.timeout) {
            // when
            _ = try await sut.fetchGithubUser(perPage: 0, since: 0)
        }
    }
    
    @Test(
        "Fetch user details success",
        arguments: MockFetchUserDetailSuccess.mocks
    )
    func fetchUserDetailsSuccess(mockUserDetails: MockFetchUserDetailSuccess) async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users/\(mockUserDetails.loginUsername)")!,
            contentType: .json,
            statusCode: 202,
            data: [
                .get: mockUserDetails.mockJSON.data(using: .utf8)!
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(2)
        mock.register()
        
        await #expect(throws: Never.self) {
            // when
            let userDetails = try await sut.fetchGithubUserDetails(loginUsername: mockUserDetails.loginUsername)
            
            // then
            #expect(mockUserDetails.loginUsername == userDetails.login)
        }
    }
    
    @Test(
        "Fetch user detail error",
        arguments: ErrorMock.mocks
    )
    func fetchUserDetailsError(mockError: ErrorMock) async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users/\(mockError.statusCode)")!,
            contentType: .json,
            statusCode: mockError.statusCode,
            data: [
                .get: Data()
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(1)
        mock.register()
        
        await #expect(throws: mockError.error) {
            // when
            _ = try await sut.fetchGithubUserDetails(loginUsername: String(mockError.statusCode))
        }
    }
    
    @Test("Fetch user details timeout")
    func fetchUserDetailsTimeOut() async {
        // given
        var mock = Mock(
            url: URL(string: "https://api.github.com/users/")!,
            contentType: .json,
            statusCode: 202,
            data: [
                .get: Data()
            ]
        )
        
        mock.delay = DispatchTimeInterval.seconds(12)
        mock.register()
        
        await #expect(throws: AFNetworkError.timeout) {
            // when
            _ = try await sut.fetchGithubUserDetails(loginUsername: "")
        }
    }
}
