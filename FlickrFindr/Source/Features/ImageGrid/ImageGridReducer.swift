import ComposableArchitecture

struct ImageGridReducer: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    struct State: Equatable {
        var photos: [PhotoItem] = []
        var page = 0
        var searchTerm = ""
        var isLoading = false
        var lastSearchWasError = false
    }
    enum Action: Equatable {
        case receiveSearchTerm(String)
        case photosResponse(TaskResult<[PhotoItem]>)
        case selectPhoto(PhotoItem)
        case checkPaging(PhotoItem)
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .checkPaging(photo):
                guard let page = nextPage(state: state, photo: photo) else {
                    return .none
                }
                state.isLoading = true
                let term = state.searchTerm
                return .task {
                    await .photosResponse(
                        TaskResult { try await self.apiClient.photoSearch(term, page) }
                    )
                }
            case .selectPhoto:
                break
            case .photosResponse(.failure):
                state.isLoading = false
                if state.photos.isEmpty {
                    state.lastSearchWasError = true
                }
            case let .photosResponse(.success(photos)):
                state.isLoading = false
                state.page += 1
                state.photos.append(contentsOf: photos)
            case .receiveSearchTerm(let term):
                state.lastSearchWasError = false
                state.searchTerm = term
                state.page = 0
                state.photos = []
                guard !term.isEmpty else {
                    return .none
                }
                state.isLoading = true
                return .task {
                    await .photosResponse(
                        TaskResult { try await self.apiClient.photoSearch(term, 0) }
                    )
                }
            }
            return .none
        }
    }
    private func nextPage(state: State, photo: PhotoItem) -> Int? {
        guard !state.isLoading, let index = state.photos.lastIndex(of: photo), index == state.photos.count - 1 else {
            return nil
        }
        return state.page
    }
}
