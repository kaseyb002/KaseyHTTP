import Foundation

extension URLSession: HTTPClient {
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    @available(tvOS 15.0, *)
    public func send(_ request: HTTPRequestable) async throws -> HTTPResponse {
        guard let url = request.url else {
            throw HTTPError(code: .invalidRequest, request: request)
        }
        
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: request.cachePolicy,
            timeoutInterval: request.timeoutInterval
        )
        
        urlRequest.httpMethod = request.method.rawValue
        
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        if let body = request.body, body.isEmpty == false {
            for (header, value) in body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
            
            do {
                urlRequest.httpBody = try body.encode()
            } catch {
                throw HTTPError(code: .invalidRequest, request: request)
            }
        }
        
        let result: HTTPResult
        do {
            let (data, urlResponse) = try await data(for: urlRequest)
            result = HTTPResult(
                request: request,
                responseData: data,
                response: urlResponse,
                error: nil
            )
        } catch let error {
            result = HTTPResult(
                request: request,
                responseData: nil,
                response: nil,
                error: error
            )
        }
        
        switch result {
        case .success(let httpResponse):
            if httpResponse.status?.isClientError == true
               ||
               httpResponse.status?.isServerError == true
            {
                throw HTTPResponseError(response: httpResponse)
            } else {
                return httpResponse
            }
            
        case .failure(let httpError):
            throw httpError
        }
    }
}

extension URLSessionDataTask: Cancellable {}
