import Alamofire
import Foundation

@MainActor
public class DataDI {
    private static var _networkShared: GithubNetwork!
    
    public static var defaultNetworkShared: GithubNetwork {
        if _networkShared == nil {
            _networkShared = GithubNetworkImpl(
                session: .default,
                decoder: JSONDecoder()
            )
        }
        return _networkShared
    }
    
    public static func registerNetwork(session: Session, decoder: JSONDecoder) {
        _networkShared = GithubNetworkImpl(
            session: .default,
            decoder: JSONDecoder()
        )
    }
}
