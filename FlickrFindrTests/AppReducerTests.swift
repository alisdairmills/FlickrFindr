import ComposableArchitecture
import XCTest

@testable import FlickrFindr

@MainActor
final class AppReducerTests: XCTestCase {

    // test image search triggered by search reducer triggers load of results in the grid reducer
    func testImageSearch() async {
        let store = TestStore(
            initialState: AppReducer.State(),
            reducer: AppReducer()
        )
        let mock: PhotoItem = .mock
        store.dependencies.apiClient.photoSearch = { _, _ in
            [mock]
        }
        await store.send(.imageSearchAction(.performSearch("test")))
        await store.receive(.imageGridAction(.receiveSearchTerm("test"))) {
            $0.imageGridState.lastSearchWasError = false
            $0.imageGridState.searchTerm = "test"
            $0.imageGridState.page = 0
            $0.imageGridState.photos = []
            $0.imageGridState.isLoading = true
        }
        await store.receive(.imageGridAction(.photosResponse(.success([mock])))) {
            $0.imageGridState.isLoading = false
            $0.imageGridState.photos = [mock]
            $0.imageGridState.page = 1
        }
    }

    // test cancel from search reducer triggers grid reducer to return to empty state
    func testImageSearchCancel() async {
        let store = TestStore(
            initialState: AppReducer.State(
                imageSearchState: ImageSearchReducer.State(),
                imageGridState: ImageGridReducer.State(photos: [.mock], page: 1, searchTerm: "test")
            ),
            reducer: AppReducer()
        )
        store.dependencies.apiClient.photoSearch = { _, _ in
            [.mock]
        }
        await store.send(.imageSearchAction(.performSearch("")))
        await store.receive(.imageGridAction(.receiveSearchTerm(""))) {
            $0.imageGridState.searchTerm = ""
            $0.imageGridState.page = 0
            $0.imageGridState.photos = []
        }
    }

    // selecting a photo from grid presents and sets the photo in the detail reducer
    func testSelectPhoto() async {
        let store = TestStore(
            initialState: AppReducer.State(),
            reducer: AppReducer()
        )
        let mock: PhotoItem = .mock
        await store.send(.imageGridAction(.selectPhoto(mock)))
        await store.receive(.detailAction(.loadPhoto(mock))) {
            $0.detailState.photo = mock
            $0.detailState.isPresented = true
        }
    }
}
