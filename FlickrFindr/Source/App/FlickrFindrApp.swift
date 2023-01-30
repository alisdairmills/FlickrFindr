import ComposableArchitecture
import SwiftUI

class Keys {
    static var FlickrKey = ""
}

@main
struct FlickrFindrApp: App {
    let store: StoreOf<AppReducer> = Store(
        initialState: AppReducer.State(),
        reducer: AppReducer()
    )
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

struct FlickrFindrApp_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: AppReducer.State(),
            reducer: AppReducer()
        )
        AppView(store: store)
    }
}
