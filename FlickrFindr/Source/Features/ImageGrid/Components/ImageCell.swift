import SwiftUI

struct ImageCell: View {
    let photo: PhotoItem
    let action: () -> Void
    var body: some View {
        GeometryReader { geometry in
            Button {
                action()
            } label: {
                ZStack {
                    AsyncImage(
                        url: URL(string: photo.thumbURL),
                        content: { image in
                            image
                                .resizable()
                        },
                        placeholder: {
                            Color.gray.opacity(0.1)
                        }
                    )
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .mask(Rectangle())
                }
            }
        }
    }
}

struct ImageCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageCell(photo: .mock) {}
            .frame(width: 140, height: 140)
        }
    }
}

extension PhotoItem {
    var thumbURL: String {
        return "https://live.staticflickr.com/" +
                server + "/" +
                photoId + "_" +
                secret +
                ".jpg"
    }
}
