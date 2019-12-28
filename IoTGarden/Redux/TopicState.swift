//
//  TopicState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/9/19.
//

import ReSwift

struct TopicState: ReSwift.StateType, Identifiable {
    var identifiableComponent = IdentifiableComponent()
    var topicItems: [ItemDetailSectionModel] = []
    var topicViewModels: [TopicViewModel] = []
    var topicViewModel: TopicViewModel?
//    var serverViewModel = ServerViewModel(id:"", name: "hvm server", server: "https//icloud.com/", title: "", isSelected: true)
    var serverViewModel: Server?
    var connectionViewModel: Server?

}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics()
        case loadConection()
        case addTopic(viewModel: TopicViewModel?)
        case removeTopic(id: String)
        case loadTopic(id: String)
        case loadConnection(id: String)
        case removeConnection()
        case fetchTopic(topicViewModel: TopicViewModel?, serverViewModel: Server?)
        case fetchTopic2(topicViewModel: TopicViewModel?, connectionViewModel: Server?)
        case updateTopic(topicViewModel: TopicViewModel?)
        case getTopic(id: String)
    }
}

extension TopicState {
    
    public static func reducer(action: ReSwift.Action, state: TopicState?) -> TopicState {
        
        var state = state ?? TopicState()
        
        guard let action = action as? TopicState.Action else { return state }
        switch action {
            
        case .loadTopics():

            let service = ItemListService()
            service.loadTopics { topics in
                state.topicViewModels = topics.map {
                   TopicViewModel(id: $0.uuid, name: $0.name, topic: "switchab", value: "1", time: "22/12/2019", serverId: "", type: "Switch")
                }
            }
            state.identifiableComponent.update()
            
        
        case .loadConnection(let id):
            let service = ItemListService()
            service.loadLocalConfiguration(uuid: id) { configuration in
                let viewModel = configuration.map {  Server(id: $0.uuid , name: $0.name , url: $0.url, user: "", password: "", port: "555", sslPort: "555" )
                    } ?? Server(id: "", name: "", url: "", user: "", password: "", port: "", sslPort: "555")
                
                state.serverViewModel = viewModel
                state.identifiableComponent.update()

            }
            
        case .fetchTopic2(let topicViewModel, let connectionViewModel):
            state.topicViewModel = topicViewModel
            state.connectionViewModel = connectionViewModel
            state.identifiableComponent.update()
            
        default: ()

        }
        
        return state

    }
}

extension TopicState {
    
    static let middleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
        
        return { next in
            print("enter detail middleware")
            return { action in
                if case TopicState.Action.addTopic(let viewModel) = action {
                    let service = ItemListService()
                    service.addTopic(topic: Topic(uuid: UUID().uuidString, name: viewModel?.name ?? "", value: "0", serverUUID: viewModel?.serverId ?? "", kind: "kind", topic: "topic", time: "waiting")) { item in
                        dispatch(TopicState.Action.loadTopics())
                    }
                }
                
                if case TopicState.Action.removeTopic(let id) = action {
                    let service = ItemListService()
                    service.removeTopic(id: id)
                    dispatch(TopicState.Action.loadTopics())
                }
                
                if case TopicState.Action.loadTopic(let id) = action {
                    let service = ItemListService()
                    service.loadTopic(uuid: id) { topic in
                        service.loadLocalConfiguration(uuid: topic?.serverUUID ?? "", finished: { configuration in
                            let topicViewModel = topic.map { _ in
                                TopicViewModel(id: topic?.uuid ?? "", name: topic?.name ?? "", topic: "", value: topic?.value ?? "", time: "", serverId: topic?.serverUUID ?? "", type: "switch" )}
                            let connectionViewModel = configuration.map { Server(id: $0.uuid, name: $0.name, url: "http://", user: "", password: "", port: "", sslPort: "555") }
                            dispatch(TopicState.Action.fetchTopic2(topicViewModel: topicViewModel, connectionViewModel: connectionViewModel))
                        })
                    }
                    dispatch(TopicState.Action.loadTopics())
                }
                
                if case TopicState.Action.updateTopic(let item) = action {
                    guard let item = item else { return }
                    let service = ItemListService()
                    service.updateTopic(topic: Topic(uuid: item.id , name: item.name, value: "1", serverUUID: item.serverId, kind: "", topic: "", time: ""))
                    dispatch(TopicState.Action.loadTopic(id: item.id))
                }
                
                if case TopicState.Action.removeConnection(let id) = action {
                    
                    let state = getState()?.topicState ?? TopicState()
                    var topicViewModel = state.topicViewModel
                    topicViewModel?.serverId = ""
                    dispatch(TopicState.Action.updateTopic(topicViewModel: topicViewModel))
                }

                next(action)
            }
        }
    }
}
