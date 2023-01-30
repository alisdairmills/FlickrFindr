import ComposableArchitecture
import SwiftUI

struct DetailView: View {

    let store: StoreOf<DetailReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            VStack {
                if let photo = viewStore.photo {
                    Text(photo.title)
                        .padding(40)
                    AsyncImage(
                        url: URL(string: photo.imageURL),
                        content: { image in
                            image
                                .resizable()
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .aspectRatio(contentMode: .fit)
                    Spacer()
                }
            }
            .onDisappear {
                viewStore.send(.dismiss)
            }
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: DetailReducer.State(isPresented: true, photo: .mock),
            reducer: DetailReducer()
        )
        DetailView(store: store)
    }
}

extension PhotoItem {
    var imageURL: String {
        return "https://live.staticflickr.com/" +
                server + "/" +
                photoId + "_" +
                secret +
                "_b.jpg"
    }
}
