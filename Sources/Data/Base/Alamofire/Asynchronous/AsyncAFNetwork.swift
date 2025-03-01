import Alamofire
import Foundation

public protocol AsyncAFNetwork { }

@available(iOS 18.0, *)
public extension AsyncAFNetwork {
    @available(macOS 10.15, *)
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
                    guard let data = response.data else {
                        continuation.resume(throwing: AFNetworkError.dataNotExist)
                        return
                    }
                    
                    guard let statusCode = response.response?.statusCode else {
                        continuation.resume(throwing: AFNetworkError.statusCodeNotExist)
                        return
                    }
#if DEBUG
                    print("Status code:", statusCode)
#endif
                    
                    switch statusCode {
                    case 200..<500:
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
                            var response = try decoder.decode(Request.Response.self, from: data)
                            response.request = restRequest
                            response.statusCode = statusCode
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
                    default:
                        if let error = String(data: data, encoding: .utf8) {
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
