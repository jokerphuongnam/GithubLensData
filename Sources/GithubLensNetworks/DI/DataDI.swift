import Alamofire
import Foundation

// A dependency injection container for providing a shared GithubNetwork instance.
public class DataDI {
    // A shared static variable to hold the singleton instance of GithubNetwork.
    // 'nonisolated(unsafe)' indicates that this property is accessed outside of any actor isolation,
    // and using 'unsafe' implies the caller must ensure thread safety manually.
    // The implicitly unwrapped optional (!) suggests that it is expected to be initialized before use.
    nonisolated(unsafe) private static var _networkShared: GithubNetwork!
    
    // A computed property that returns the shared GithubNetwork instance.
    // If it hasn't been initialized yet, it creates a new GithubNetworkImpl using default settings.
    public static var defaultNetworkShared: GithubNetwork {
        if _networkShared == nil {
            _networkShared = GithubNetworkImpl(
                session: .default,          // Uses the default Alamofire session.
                decoder: JSONDecoder()      // Creates a new JSONDecoder instance.
            )
        }
        return _networkShared
    }
    
    // Allows registering or replacing the shared GithubNetwork instance with custom dependencies.
    // Note: The provided 'session' and 'decoder' parameters are currently not used; instead,
    // it creates a new instance with default session and a new JSONDecoder.
    // Consider updating this to use the passed parameters if customization is desired:
    //    session: session, decoder: decoder
    public static func registerNetwork(session: Session, decoder: JSONDecoder) {
        _networkShared = GithubNetworkImpl(
            session: .default,          // Currently, defaults to the default session.
            decoder: JSONDecoder()      // And creates a new JSONDecoder.
        )
    }
}
