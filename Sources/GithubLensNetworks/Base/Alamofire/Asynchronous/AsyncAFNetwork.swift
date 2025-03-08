import Alamofire
import Foundation

protocol AsyncAFNetwork { }

extension AsyncAFNetwork {
    // This asynchronous function sends a network request using Alamofire,
    // decodes the response into a generic type, and handles errors accordingly.
    func send<Request: AFRequest>(session: Session, decoder: JSONDecoder, request: Request) async throws -> Request.Response {
        // Create the Alamofire request with all necessary parameters from the Request protocol.
        let restRequest = session.request(
            request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.httpHeaderFields,
            interceptor: request.interceptor
        )
        
        // Use withTaskCancellationHandler to ensure that if the task is cancelled,
        // the underlying network request is also cancelled.
        return try await withTaskCancellationHandler {
            // Convert the callback-based Alamofire API to async/await using checked throwing continuation.
            return try await withCheckedThrowingContinuation { continuation in
#if DEBUG
                // In debug mode, create a background queue to avoid blocking the main thread.
                let backgroundQueue = DispatchQueue.init(
                    label: "\(self.self)",
                    qos: .background
                )
                
                // Print the cURL description of the request for debugging purposes.
                restRequest.cURLDescription(
                    on: backgroundQueue
                ) { description in
                    print("Request \(description)")
                }
#endif
                // Set up the response handler to decode the response into the expected type.
                restRequest.responseDecodable(
                    of: Request.Response.self,
                    queue: DispatchQueue.init(
                        label: "\(self.self)",
                        qos: .utility
                    )
                ) { response in
                    let data = response.data
                    // Ensure the HTTP status code is available.
                    guard let statusCode = response.response?.statusCode else {
                        // If the request timed out, resume with a timeout error.
                        if case .sessionTaskFailed(URLError.timedOut) = response.error {
                            continuation.resume(throwing: AFNetworkError.timeout)
                        } else if let error = response.error {
#if DEBUG
                            // Print the error on a background queue in debug mode.
                            backgroundQueue.async {
                                print("error: ", error)
                            }
#endif
                            // Resume with a generic error wrapped in AFNetworkError.
                            continuation.resume(
                                throwing: AFNetworkError.otherError(
                                    AFResponseError(
                                        status: false,
                                        message: error.localizedDescription,
                                        statusCode: nil
                                    )
                                )
                            )
                        }
                        return
                    }
#if DEBUG
                    // Log the received status code for debugging.
                    backgroundQueue.async {
                        print("Status code:", statusCode)
                    }
#endif
                    
                    // Process response based on the status code.
                    switch statusCode {
                        // For successful status codes (200..<300), try to decode the response.
                    case 200..<300:
                        guard let data else {
                            continuation.resume(throwing: AFNetworkError.dataNotExist)
                            return
                        }
#if DEBUG
                        // Log the raw response data (as a string) for debugging purposes.
                        backgroundQueue.async {
                            print("==============================================")
                            if let returnData = String(data: data, encoding: .utf8) {
                                print(String(returnData))
                            } else {
                                print("Can't parse to String data")
                            }
                        }
#endif
                        do {
                            // Decode the JSON data into the expected type.
                            let response = try decoder.decode(Request.Response.self, from: data)
                            continuation.resume(returning: response)
                        } catch {
#if DEBUG
                            // Log any decoding errors.
                            backgroundQueue.async {
                                print("error: ", error)
                            }
#endif
                            // Resume with an unknown error wrapping the decoding error.
                            continuation.resume(
                                throwing: AFNetworkError.unknownError(
                                    AFResponseError(
                                        error.localizedDescription,
                                        statusCode: statusCode
                                    )
                                )
                            )
                        }
                        // Specific handling for 403 Forbidden.
                    case 403:
                        continuation.resume(throwing: AFNetworkError.forbidden)
                        // Specific handling for 404 Not Found.
                    case 404:
                        continuation.resume(throwing: AFNetworkError.notFound)
                        // Handle server errors (500 and above).
                    case 500...:
                        continuation.resume(throwing: AFNetworkError.serverError)
                        // Default error handling for any other status codes.
                    default:
                        if let data, let error = String(data: data, encoding: .utf8) {
                            continuation.resume(
                                throwing: AFNetworkError.otherError(
                                    AFResponseError(
                                        error,
                                        statusCode: statusCode
                                    )
                                )
                            )
                        } else {
                            continuation.resume(
                                throwing: AFNetworkError.otherError(
                                    AFResponseError(
                                        false,
                                        statusCode: statusCode
                                    )
                                )
                            )
                        }
                    }
                }
            }
        } onCancel: {
            // Cancel the Alamofire request if the Swift concurrency task is cancelled.
            restRequest.cancel()
        }
    }
}
