import ComposableArchitecture
import Foundation

public struct APIClient {
    var photoSearch: @Sendable (String, Int) async throws -> [PhotoItem]
}

extension APIClient: DependencyKey {
    public static var liveValue: APIClient = APIClient { term, page in
        let apiRequest = APIRequest()
        let response: Result<PhotosResult, Error> =
            try await apiRequest.execute(endPoint: PhotoSearch.search(term, page))
        switch response {
        case .success(let result):
            return result.photos.photo.compactMap {
                $0.item
            }
        case .failure(let error):
            throw error
        }
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: TestDependencyKey {
    public static let previewValue = Self(photoSearch: { _, _ in
        var tmp: [Photo] = []
        while tmp.count < 24 {
            tmp.append(.mock)
        }
        return tmp.compactMap{
            $0.item
        }
    })
    public static let testValue = Self(
        photoSearch: unimplemented("\(Self.self).photoSearch")
    )
}
