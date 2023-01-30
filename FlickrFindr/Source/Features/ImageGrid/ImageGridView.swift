import ComposableArchitecture
import SwiftUI

struct ImageGridView: View {

    let store: StoreOf<ImageGridReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            GeometryReader { geometry in
                let width = (geometry.size.width - 40) / 3
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.fixed(width)),
                                            GridItem(.fixed(width)),
                                            GridItem(.fixed(width))]) {
                            ForEach(viewStore.photos, id: \.id) { photo in
                                ImageCell(photo: photo, action: {
                                    viewStore.send(.selectPhoto(photo))
                                })
                                .onAppear {
                                    viewStore.send(.checkPaging(photo))
                                }
                                .frame(width: width, height: width)
                            }
                        }
                    }
                    ProgressView()
                        .opacity(viewStore.isLoading && viewStore.photos.isEmpty ? 1 : 0)
                    Text(viewStore.lastSearchWasError ?
                         "something went wrong - try another search" : "search for something!")
                        .opacity(!viewStore.isLoading && viewStore.photos.isEmpty ? 1 : 0)
                }
                .navigationTitle("Flickr Findr")
            }
        })
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: ImageGridReducer.State(photos: [.mock, .mock], isLoading: false, lastSearchWasError: false),
            reducer: ImageGridReducer()
        )
        ImageGridView(store: store)
    }
}
