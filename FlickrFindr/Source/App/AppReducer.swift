import ComposableArchitecture

struct AppReducer: ReducerProtocol {
    struct State: Equatable {
        var imageSearchState: ImageSearchReducer.State = ImageSearchReducer.State()
        var imageGridState: ImageGridReducer.State = ImageGridReducer.State()
        var detailState: DetailReducer.State = DetailReducer.State()
    }
    enum Action: Equatable {
        case imageSearchAction(ImageSearchReducer.Action)
        case imageGridAction(ImageGridReducer.Action)
        case detailAction(DetailReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.imageSearchState, action: /Action.imageSearchAction) {
            ImageSearchReducer()
        }
        Scope(state: \.imageGridState, action: /Action.imageGridAction) {
            ImageGridReducer()
        }
        Scope(state: \.detailState, action: /Action.detailAction) {
            DetailReducer()
        }
        Reduce { _, action in
            switch action {
            case let .imageSearchAction(.performSearch(term)):
                return .run { send in
                    await send.send(.imageGridAction(.receiveSearchTerm(term)))
                }
            case .imageSearchAction(.cancelSearch):
                return .run { send in
                    await send.send(.imageGridAction(.receiveSearchTerm("")))
                }
            case let .imageGridAction(.selectPhoto(photo)):
                return .run { send in
                    await send.send(.detailAction(.loadPhoto(photo)))
                }
            default:
                break
            }
            return .none
        }
    }
}
