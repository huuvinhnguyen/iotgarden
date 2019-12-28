//
//  ConnectionState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/14/19.
//

import ReSwift

struct ConnectionState: ReSwift.StateType, Identifiable {
    var identifiableComponent = IdentifiableComponent()
    var viewModels: [Server] = []
    var servers: [Server] = []
    var server: Server?

}

extension ConnectionState {
    enum Action: ReSwift.Action {
        case addServer(_ model: Server)
        case updateServer(Server)
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
                state.servers = configurations.map { Server(id: $0.uuid ,name: $0.name, url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort) }
            }
            
            state.identifiableComponent.update()
            
        case .loadConnection(let id):
            let service = ItemListService()
            service.loadLocalConfiguration(uuid: id) { configuration in
                let viewModel = configuration.map {  Server(id: $0.uuid , name: $0.name , url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort)}
                
                state.server = viewModel
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
                
                if case ConnectionState.Action.addServer(let server) = action {
                    let service = ItemListService()
                    service.addConfiguration(configuration: ItemListService.Server(uuid: server.id, name: server.name, url: server.url, username: server.user, password: server.password, port: server.password, sslPort: server.sslPort), finished: { id in
                        
                        dispatch(ConnectionState.Action.loadConnections())
                    })
                }
                
                if case ConnectionState.Action.updateServer(let server) = action {
                    let service = ItemListService()
                    service.updateConfiguration(configuration: ItemListService.Server(uuid: server.id, name: server.name, url: server.url, username: server.user, password: server.password, port: server.password, sslPort: server.sslPort), finished: { id in
                        
                        dispatch(ConnectionState.Action.loadConnections())
                    })
                }
                
                next(action)
            }
        }
    }
}
