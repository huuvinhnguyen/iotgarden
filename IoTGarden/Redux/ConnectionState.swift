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
