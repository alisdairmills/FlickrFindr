import ComposableArchitecture

struct DetailReducer: ReducerProtocol {
    struct State: Equatable {
        var isPresented = false
        var photo: PhotoItem?
    }
    enum Action: Equatable {
        case presented
        case loadPhoto(PhotoItem)
        case dismiss
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .loadPhoto(photo):
                state.photo = photo
                state.isPresented = true
            case .dismiss:
                state.photo = nil
                state.isPresented = false
            case .presented:
                break
            }
            return .none
        }
    }
}
