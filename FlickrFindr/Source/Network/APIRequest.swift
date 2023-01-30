import Foundation

struct APIRequest {
    func execute<T>(endPoint: APIEndPoint) async throws -> (Result<T, Error>) where T: Decodable {
        do {
            let request = try endPoint.urlRequest()
            let (data, _) = try await URLSession.shared.data(for: request)
            let value = try JSONDecoder().decode(T.self, from: data)
            return .success(value)
        } catch let error {
            throw error
        }
    }
}
