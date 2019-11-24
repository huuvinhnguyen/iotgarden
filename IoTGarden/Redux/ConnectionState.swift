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
    var serverViewModel: ServerViewModel?

}

extension ConnectionState {
    enum Action: ReSwift.Action {
        case addConnection(viewModel: ConnectionViewModel)
        case updateConnection(viewModel: ConnectionViewModel)
        case removeConnection(id: String)
        case loadConnection(id: String)
        case loadConnections()
        case selectConnection(id: String)
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
            
        case .loadConnection(let id):
            let service = ItemListService()
            service.loadLocalConfiguration(uuid: id) { configuration in
                let viewModel = configuration.map {  ServerViewModel(id: $0.uuid , name: $0.name , url: $0.server )} 
                
                state.serverViewModel = viewModel
                state.identifiableComponent.update()
            }
            
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
                
                if case ConnectionState.Action.addConnection(let viewModel) = action {
                    let service = ItemListService()
                    service.addConfiguration(configuration: ItemListService.Configuration(uuid: viewModel.id, name: viewModel.name, server: viewModel.server, username: "", password: "", port: ""), finished: { id in
                        
                        dispatch(ConnectionState.Action.loadConnections())
                    })
                }
                next(action)
            }
        }
    }
}
