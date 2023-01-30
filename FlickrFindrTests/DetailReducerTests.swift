import ComposableArchitecture
import XCTest

@testable import FlickrFindr

@MainActor
final class DetailReducerTests: XCTestCase {

    // loading a photo sets photo object and sets presented
    func testLoadPhoto() async {
        let store = TestStore(
            initialState: DetailReducer.State(),
            reducer: DetailReducer()
        )
        let mock: PhotoItem = .mock
        await store.send(.loadPhoto(mock)) {
            $0.photo = mock
            $0.isPresented = true
        }
    }

    // dismiss sets photo to nil and presented to false
    func testDismiss() async {
        let store = TestStore(
            initialState: DetailReducer.State(isPresented: true, photo: .mock),
            reducer: DetailReducer()
        )
        await store.send(.dismiss) {
            $0.isPresented = false
            $0.photo = nil
        }
    }

}
