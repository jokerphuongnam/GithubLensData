import Alamofire

// Defines AFResponse as a combination of protocols that any response type must conform to.
// - Decodable: The type can be decoded from external representations (e.g., JSON).
// - Hashable: The type supports hashing, enabling its use in collections like dictionaries or sets.
// - Sendable: The type is safe to be transferred across concurrency domains.
public typealias AFResponse = Decodable & Hashable & Sendable
