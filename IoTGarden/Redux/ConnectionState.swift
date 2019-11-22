//
//  ConnectionState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/14/19.
//

import ReSwift

struct ConnectionState: ReSwift.StateType, Identifiable {
    var identifiableComponent = IdentifiableComponent()
    var viewModels: [ConnectionViewModel] = []
    var servers: [ServerViewModel] = []

}

extension ConnectionState {
    enum Action: ReSwift.Action {
        case addConnection(viewModel: ConnectionViewModel)
        case updateConnection(viewModel: ConnectionViewModel)
        case removeConnection(id: String)
        case loadConnection(id: String)
        case loadConnections()
    }
}

extension ConnectionState {
    
    public static func reducer(action: ReSwift.Action, state: ConnectionState?) -> ConnectionState {
        
        var state = state ?? ConnectionState()
        
        guard let action = action as? ConnectionState.Action else { return state }

        
        switch action {
            
        case .loadConnections():
            
            let service = ItemListService()
            service.loadConfigures { configurations in
                state.servers = configurations.map { ServerViewModel(id: $0.uuid ,name: $0.name, url: $0.server) }
            }
            
            state.identifiableComponent.update()
            
        default: ()
        
        }
        
        return state
    }
    
}

extension ConnectionState {
    static let middleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
        
        return { next in
            print("enter detail middleware")
            return { action in
                if case ConnectionState.Action.removeConnection(let id) = action {
                    let service = ItemListService()
                    service.deleteConfigure(id: id, finished: { id in
                        dispatch(ConnectionState.Action.loadConnections())
                    })
                }
                
                if case TopicState.Action.removeTopic(let id) = action {
                    let service = ItemListService()
                    service.removeTopic(id: id)
                    dispatch(TopicState.Action.loadTopics())
                }
                
                next(action)
            }
        }
    }
}
