import Alamofire
import Foundation

protocol AsyncAFNetwork { }

extension AsyncAFNetwork {
    func send<Request: AFRequest>(session: Session, decoder: JSONDecoder, request: Request) async throws -> Request.Response {
        let restRequest = session.request(
            request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.httpHeaderFields,
            interceptor: request.interceptor
        )
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
#if DEBUG
                let backgroundQueue = DispatchQueue.init(
                    label: "\(self.self)",
                    qos: .background
                )
                
                restRequest.cURLDescription(
                    on: backgroundQueue
                ) { description in
                    print("Request \(description)")
                }
#endif
                restRequest.responseDecodable(
                    of: Request.Response.self,
                    queue: DispatchQueue.init(
                        label: "\(self.self)",
                        qos: .utility
                    )
                ) { response in
                    let data = response.data
                    guard let statusCode = response.response?.statusCode else {
                        if case .sessionTaskFailed(URLError.timedOut) = response.error {
                            continuation.resume(throwing: AFNetworkError.timeout)
                        } else if let error = response.error {
#if DEBUG
                            backgroundQueue.async {
                                print("error: ", error)
                            }
#endif
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
                    backgroundQueue.async {
                        print("Status code:", statusCode)
                    }
#endif
                    
                    switch statusCode {
                    case 200..<300:
                        guard let data else {
                            continuation.resume(throwing: AFNetworkError.dataNotExist)
                            return
                        }
#if DEBUG
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
                            let response = try decoder.decode(Request.Response.self, from: data)
                            continuation.resume(returning: response)
                        } catch {
#if DEBUG
                            backgroundQueue.async {
                                print("error: ", error)
                            }
#endif
                            continuation.resume(
                                throwing: AFNetworkError.unknownError(
                                    AFResponseError(
                                        error.localizedDescription,
                                        statusCode: statusCode
                                    )
                                )
                            )
                        }
                    case 404:
                        continuation.resume(throwing: AFNetworkError.notFound)
                    case 500...:
                        continuation.resume(throwing: AFNetworkError.serverError)
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
            restRequest.cancel()
        }
    }
}
