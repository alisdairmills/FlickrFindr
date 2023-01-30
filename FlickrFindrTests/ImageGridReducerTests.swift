import ComposableArchitecture
import XCTest

@testable import FlickrFindr

@MainActor
final class ImageGridReducerTests: XCTestCase {

    // test results triggered by search string are populated
    func testReceiveSearchString() async {
        let store = TestStore(
            initialState: ImageGridReducer.State(),
            reducer: ImageGridReducer()
        )
        let mock: PhotoItem = .mock
        store.dependencies.apiClient.photoSearch = { _, _ in
            [mock]
        }
        await store.send(.receiveSearchTerm("test")) {
            $0.lastSearchWasError = false
            $0.searchTerm = "test"
            $0.page = 0
            $0.photos = []
            $0.isLoading = true
        }
        await store.receive(.photosResponse(.success([mock]))) {
            $0.isLoading = false
            $0.photos = [mock]
            $0.page = 1
        }
    }

    // test results set to empty when empty string search occurs (by pressing cancel)
    func testReceiveSearchEmptyString() async {
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [.mock], page: 1, searchTerm: "test"),
            reducer: ImageGridReducer()
        )
        store.dependencies.apiClient.photoSearch = { _, _ in
            [.mock]
        }
        await store.send(.receiveSearchTerm("")) {
            $0.searchTerm = ""
            $0.page = 0
            $0.photos = []
        }
    }

    // check paging is triggered if current last item is reached
    func testCheckPagingNeeded() async {
        let mock1: PhotoItem = .mock
        let mock2: PhotoItem = .mock
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [mock1], page: 1, searchTerm: "test"),
            reducer: ImageGridReducer()
        )
        store.dependencies.apiClient.photoSearch = { _, _ in
            [mock2]
        }
        await store.send(.checkPaging(mock1)) {
            $0.isLoading = true
        }
        await store.receive(.photosResponse(.success([mock2]))) {
            $0.isLoading = false
            $0.photos = [mock1, mock2]
            $0.page = 2
        }
    }

    // check paging is not triggered if already loading if current last item is reached
    func testCheckPagingNeededButLoading() async {
        let mock1: PhotoItem = .mock
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [mock1], page: 1, searchTerm: "test", isLoading: true),
            reducer: ImageGridReducer()
        )
        store.dependencies.apiClient.photoSearch = { _, _ in
            [.mock]
        }
        await store.send(.checkPaging(mock1))
    }

    // check paging isn't triggered when requested by a photo that isn't the last item
    func testCheckPagingNotNeeded() async {
        let mock1: PhotoItem = .mock
        let mock2: PhotoItem = .mock
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [mock1, mock2], page: 1, searchTerm: "test"),
            reducer: ImageGridReducer()
        )
        await store.send(.checkPaging(mock1))
    }

    // check photo list populated on success reponse
    func testPhotoResponseSuccess() async {
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [], page: 0, isLoading: true),
            reducer: ImageGridReducer()
        )
        let mock: PhotoItem = .mock
        store.dependencies.apiClient.photoSearch = { _, _ in
            [mock]
        }
        await store.send(.photosResponse(.success([mock]))) {
            $0.isLoading = false
            $0.photos = [mock]
            $0.page = 1
        }
    }

    // test failure flag is triggered on response fail
    func testPhotosResponseFailure() async {
        let store = TestStore(
            initialState: ImageGridReducer.State(photos: [], page: 0, isLoading: true),
            reducer: ImageGridReducer()
        )
        store.dependencies.apiClient.photoSearch = { _, _ in
            [.mock]
        }
        await store.send(.photosResponse(.failure(APIError.invalidURL))) {
            $0.isLoading = false
            $0.lastSearchWasError = true
        }
    }
}
