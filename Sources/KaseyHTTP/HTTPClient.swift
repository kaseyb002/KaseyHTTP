import Foundation

public protocol HTTPClient: Sendable {
    func send(_ request: HTTPRequestable) async throws -> HTTPResponse
}
