import ComposableArchitecture
import SwiftUI

struct ImageSearchView: View {

    let store: StoreOf<ImageSearchReducer>
    @State private var searchText = ""
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            ZStack {
            }
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { newValue in
                if newValue.isEmpty && !isSearching {
                    viewStore.send(.cancelSearch)
                }
            })
            .onSubmit(of: .search) {
                viewStore.send(.performSearch(searchText))
            }
        })
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: ImageSearchReducer.State(),
            reducer: ImageSearchReducer()
        )
        NavigationStack {
            ImageSearchView(store: store)
        }
    }
}
