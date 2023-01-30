import Foundation

struct PhotosResult: Decodable, Equatable {
    let photos: Photos
}

struct Photos: Decodable, Equatable {
    let photo: [Photo]
}

struct Photo: Decodable, Equatable {
    let id: String
    let secret: String
    let server: String
    let title: String
    var item: PhotoItem {
        PhotoItem(photoId: id, secret: secret, server: server, title: title)
    }
    static var mock: Photo {
        .init(id: "40677370771", secret: "0363318b28", server: "4616", title: "Mock title")
    }
}

enum PhotoSearch {
    case search(String, Int)
}

extension PhotoSearch: APIEndPoint {

    var path: String {
        switch self {
        case let .search(term, page):
            return "https://www.flickr.com/services/rest/?method=flickr.photos.search" +
                    "&api_key=\(Keys.FlickrKey)" +
                    "&text=\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term)" +
                    "&page=\(page)" +
                    "&per_page=24" +
                    "&format=json" +
                    "&nojsoncallback=1" +
                    "&content_type=1"
        }
    }

    var method: String {
        "GET"
    }

}
