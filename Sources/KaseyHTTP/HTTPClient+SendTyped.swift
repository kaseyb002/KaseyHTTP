import Foundation

// MARK: Typed Requests
extension HTTPClient {
    public func sendTyped<R: TypedHTTPRequestable> (_ request: R) async throws -> R.ResponseType {
        let response: HTTPResponse = try await send(request)
        let data: R.ResponseType = try request.parse(response)
        return data
    }
}
