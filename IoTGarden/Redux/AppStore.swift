//
//  AppStore.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/10/19.
//

import ReSwift
import ReSwiftRouter

var appStore = ReSwift.Store<AppState>(
    reducer: appReduce,
    state: nil,
    middleware: [ItemState.middleware, TopicState.middleware, ServerState.middleware])

func appReduce(action: ReSwift.Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.navigationState = NavigationReducer.handleAction(action, state: state.navigationState)
    state.topicState = TopicState.reducer(action: action, state: state.topicState)
    state.itemState = ItemState.reducer(action: action,state: state.itemState)
    state.serverState = ServerState.reducer(action: action, state: state.serverState)
    
    return state
}

struct IdentifiableComponent : Hashable {
    
    typealias Identifier = UInt64
    
    private struct Counter {
        static let lock = DispatchSemaphore(value: 1)
        static var count: Identifier = 0
        static func getAndIncrement() -> Identifier {
            lock.wait()
            defer { lock.signal() }
            count += 1
            return count
        }
    }
    
    private(set) var identifier: Identifier = Counter.getAndIncrement()
    
    var hashValue: Int { return identifier.hashValue }
    
    mutating func update() {
        identifier = Counter.getAndIncrement()
    }
}

protocol HasIdentifiableComponent : Equatable {
    var identifiableComponent: IdentifiableComponent { get }
}

protocol Identifiable : HasIdentifiableComponent {
}

extension Identifiable {
    
    var identifier: IdentifiableComponent.Identifier {
        return identifiableComponent.identifier
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifiableComponent == rhs.identifiableComponent
    }
}
