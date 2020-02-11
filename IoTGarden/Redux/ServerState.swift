//
//  ConnectionState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/14/19.
//

import ReSwift

struct ServerState: ReSwift.StateType, Identifiable {
    var identifiableComponent = IdentifiableComponent()
    var viewModels: [Server] = []
    var servers: [Server] = []
    var server: Server?

}

extension ServerState {
    enum Action: ReSwift.Action {
        case addServer(_ model: Server)
        case updateServer(Server)
        case removeConnection(id: String)
        case loadServer(id: String)
        case loadConnections()
        case selectConnection(id: String)
    }
}

extension ServerState {
    
    public static func reducer(action: ReSwift.Action, state: ServerState?) -> ServerState {
        
        var state = state ?? ServerState()
        
        guard let action = action as? ServerState.Action else { return state }

        
        switch action {
            
        case .loadConnections():
            
            let service = ItemListService()
            service.loadConfigures { configurations in
                state.servers = configurations.map { Server(id: $0.uuid ,name: $0.name, url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort, canDelete: true) }
            }
            
            state.identifiableComponent.update()
            
        case .loadServer(let id):
            let service = ItemListService()
            service.loadServer(uuid: id) { configuration in
                let server = configuration.map {  Server(id: $0.uuid , name: $0.name , url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort, canDelete: true)}
                
                state.server = server
                state.identifiableComponent.update()
            }
            
        default: ()
        
        }
        
        return state
    }
    
}

extension ServerState {
    static let middleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
        
        return { next in
            print("enter detail middleware")
            return { action in
                if case ServerState.Action.removeConnection(let id) = action {
                    let service = ItemListService()
                    service.deleteConfigure(id: id, finished: { id in
                        dispatch(ServerState.Action.loadConnections())
                    })
                }
                
                if case ServerState.Action.addServer(let server) = action {
                    let service = ItemListService()
                    service.addConfiguration(configuration: ItemListService.Server(uuid: server.id, name: server.name, url: server.url, username: server.user, password: server.password, port: server.port, sslPort: server.sslPort), finished: { id in
                        
                        dispatch(ServerState.Action.loadConnections())
                    })
                }
                
                if case ServerState.Action.updateServer(let server) = action {
                    let service = ItemListService()
                    service.updateConfiguration(configuration: ItemListService.Server(uuid: server.id, name: server.name, url: server.url, username: server.user, password: server.password, port: server.port, sslPort: server.sslPort), finished: { id in
                        
                        dispatch(ServerState.Action.loadConnections())
                    })
                }
                
                next(action)
            }
        }
    }
}
