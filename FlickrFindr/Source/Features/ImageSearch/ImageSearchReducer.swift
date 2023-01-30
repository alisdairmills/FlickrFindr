import ComposableArchitecture

struct ImageSearchReducer: ReducerProtocol {
    struct State: Equatable {
    }
    enum Action: Equatable {
        case performSearch(String)
        case cancelSearch
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { _, _ in
            return .none
        }
    }
}
