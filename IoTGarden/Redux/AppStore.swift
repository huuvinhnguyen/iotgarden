//
//  AppStore.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/10/19.
//

import ReSwift

var appStore = ReSwift.Store<AppState>(
    reducer: appReduce,
    state: nil,
    middleware: [switchingMiddleware, inputMiddleware, itemListMiddleware, imageMiddleware, TopicState.middleware, ConnectionState.middleware])

func appReduce(action: ReSwift.Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.topicState = TopicState.reducer(action: action, state: state.topicState)
    state.listState = ItemState.reducer(action: action,state: state.listState)
//    state.detailState = ItemDetailState.reducer(action: action, state: state.detailState)
    state.connectionState = ConnectionState.reducer(action: action, state: state.connectionState)
    
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
