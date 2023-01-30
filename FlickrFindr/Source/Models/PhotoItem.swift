import Foundation

struct PhotoItem: Equatable {
    var id = UUID().uuidString
    let photoId: String
    let secret: String
    let server: String
    let title: String

    static var mock: PhotoItem {
        .init(photoId: "40677370771", secret: "0363318b28", server: "4616", title: "Mock title")
    }
}
