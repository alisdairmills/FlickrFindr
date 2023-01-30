import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            NavigationStack {
                ImageSearchView(store: self.store.scope(
                    state: \.imageSearchState,
                    action: AppReducer.Action.imageSearchAction)
                )
                ImageGridView(store: self.store.scope(
                    state: \.imageGridState,
                    action: AppReducer.Action.imageGridAction)
                )
            }
            .sheet(isPresented: viewStore.binding(
                get: \.detailState.isPresented,
                send: AppReducer.Action.detailAction(.presented))
            ) {
                DetailView(store: self.store.scope(
                    state: \.detailState,
                    action: AppReducer.Action.detailAction)
                )
            }
        })
        .onAppear {
            if Keys.FlickrKey.isEmpty {
                fatalError("Enter a key for Flickr")
            }
        }
    }
}
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: AppReducer.State(),
            reducer: AppReducer()
        )
        AppView(store: store)
    }
}
