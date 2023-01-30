import Foundation

protocol APIEndPoint {
    var path: String { get }
    var method: String { get }
}

extension APIEndPoint {

    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }

}
