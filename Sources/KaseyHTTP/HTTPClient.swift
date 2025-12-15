import Foundation

public protocol HTTPClient {
    func send(_ request: HTTPRequestable) async throws -> HTTPResponse
}
