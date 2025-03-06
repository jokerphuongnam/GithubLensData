# Github Network Library

A lightweight Swift networking library built on top of Alamofire for interacting with the Github API using Swift's async/await concurrency. This library provides a clean, type-safe, and extensible network abstraction layer for fetching Github user lists and user details.

## Features

- **Swift Concurrency**: Fully leverages async/await for modern asynchronous programming.
- **Alamofire Integration**: Uses Alamofire for robust and flexible network requests.
- **Type-Safe API**: Utilizes protocols and generics to ensure compile-time type safety.
- **Dependency Injection**: Simple DI container for managing shared network instances.
- **Debug Logging**: Optional logging for requests and responses to aid in debugging (enabled in DEBUG mode).

## Requirements

- Swift 5.5+
- Xcode 13+
- [Alamofire](https://github.com/Alamofire/Alamofire)

## Installation

You can integrate this library into your project using Swift Package Manager (SPM):

1. In Xcode, navigate to **File > Swift Packages > Add Package Dependency**.
2. Enter the repository URL:  
   `https://github.com/yourusername/yourrepository.git`
3. Follow the prompts to add the package to your project.

## Usage

### Fetching a List of Github Users

```swift
import Alamofire
import GithubLensNetworks

// Access the shared network instance
let network = DataDI.defaultNetworkShared

Task {
    do {
        // Fetch a paginated list of Github users
        let users = try await network.fetchGithubUser(perPage: 20, since: 0)
        print(users)
    } catch {
        print("Error fetching users: \(error)")
    }
}
