//
//  TopicState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/9/19.
//

import ReSwift

struct TopicState: ReSwift.StateType, Identifiable {
    var identifiableComponent = IdentifiableComponent()
    var topics: [Topic] = []
    var topic: Topic?
    var server: Server?
}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics()
        case loadConection()
        case addTopic(viewModel: Topic?)
        case removeTopic(id: String)
        case loadTopic(id: String)
        case loadConnection(id: String)
        case removeConnection()
        case fetchTopic(topicViewModel: Topic?, connectionViewModel: Server?)
        case updateTopic(topicViewModel: Topic?)
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
                state.topics = topics.map {
                    Topic(id: $0.uuid, name: $0.name, topic: $0.topic, value: $0.value, time: $0.time, serverId: $0.serverUUID, type: "Switch", qos: "0")
                }
            }
            state.identifiableComponent.update()
            
        
        case .loadConnection(let id):
            let service = ItemListService()
            service.loadLocalConfiguration(uuid: id) { configuration in
                let viewModel = configuration.map {  Server(id: $0.uuid , name: $0.name , url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort)
                    }
                
                state.server = viewModel
                state.identifiableComponent.update()

            }
            
        case .fetchTopic(let topicViewModel, let connectionViewModel):
            state.topic = topicViewModel
//            state.connectionViewModel = connectionViewModel
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
                    let id = viewModel?.id ?? ""
                    service.addTopic(topic: ItemListService.TopicData(uuid: id, name: viewModel?.name ?? "", value: viewModel?.value ?? "", serverUUID: viewModel?.serverId ?? "", kind: viewModel?.type ?? "", topic: viewModel?.topic ?? "", time: viewModel?.time ?? "")) { item in
                        dispatch(TopicState.Action.loadTopics())
                        dispatch(TopicState.Action.loadTopic(id: id))

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
                        service.loadLocalConfiguration(uuid: topic?.serverUUID ?? "", finished: { server in
                            let topicViewModel = topic.map { _ in
                                Topic(id: topic?.uuid ?? "", name: topic?.name ?? "", topic: topic?.topic ?? "", value: topic?.value ?? "", time: topic?.time ?? "", serverId: topic?.serverUUID ?? "", type: "switch", qos: "2")}
                            let connectionViewModel = server.map { Server(id: $0.uuid, name: $0.name, url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort) }
                            dispatch(TopicState.Action.fetchTopic(topicViewModel: topicViewModel, connectionViewModel: connectionViewModel))
                            dispatch(ServerState.Action.loadServer(id: topic?.serverUUID ?? ""))
                        })
                    }
                    dispatch(TopicState.Action.loadTopics())
                }
                
                if case TopicState.Action.updateTopic(let item) = action {
                    guard let item = item else { return }
                    let service = ItemListService()
                    service.updateTopic(topic: ItemListService.TopicData(uuid: item.id , name: item.name, value: item.value, serverUUID: item.serverId, kind: item.type, topic: item.topic, time: item.time))
                    dispatch(TopicState.Action.loadTopic(id: item.id))
                }
                
                if case TopicState.Action.removeConnection(let id) = action {
                    
                    let state = getState()?.topicState ?? TopicState()
                    var topicViewModel = state.topic
                    topicViewModel?.serverId = ""
                    dispatch(TopicState.Action.updateTopic(topicViewModel: topicViewModel))
                }

                next(action)
            }
        }
    }
}
