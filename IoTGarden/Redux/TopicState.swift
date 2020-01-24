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
    var editableTopic: Topic?
    var tasks: [String: TopicConnector] = [:]

}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics(itemId: String)
        case fetchTopics(topics: [Topic])
        case loadConection()
        case addTopic(topic: Topic?)
        case removeTopic(id: String)
        case loadTopic(id: String)
        case removeConnection()
        case fetchTopic(topic: Topic?)
        case fetchEditableTopic(topic: Topic?)
        case updateTopic(topic: Topic?)
        case getTopic(id: String)
        case updateTask(topic: Topic)
        case fetchTask(topicId: String, task: TopicConnector)
        case publish(topicId: String, message: String)
        case stopAllTasks()
    }
}

extension TopicState {
    
    public static func reducer(action: ReSwift.Action, state: TopicState?) -> TopicState {
        
        var state = state ?? TopicState()
        
        guard let action = action as? TopicState.Action else { return state }
        switch action {
            
        case .fetchTopics(let topics):
            state.topics = topics
            state.identifiableComponent.update()

        case .fetchTopic(let topic):
            state.topic = topic
            state.identifiableComponent.update()
            
        case .fetchEditableTopic(let topic):
            state.editableTopic = topic
            state.identifiableComponent.update()

        case Action.fetchTask(let topicId, let task):
            if state.tasks[topicId] == nil {
                task.connect()
                state.tasks[topicId] = task
//                state.identifiableComponent.update()
            }
            
        case Action.publish(let topicId, let message):
                let task = state.tasks[topicId]
                task?.publish(message: message)
            
        case Action.stopAllTasks():
            state.tasks.forEach { $0.value.disconnect() }
            
            
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
                if case TopicState.Action.addTopic(let topic) = action {
                    let service = ItemListService()
                    let id = topic?.id ?? ""
                    service.addTopic(topic: ItemListService.TopicData(uuid: id, name: topic?.name ?? "", value: topic?.value ?? "", serverUUID: topic?.serverId ?? "", kind: topic?.type ?? "", topic: topic?.topic ?? "", time: topic?.time ?? "",  message: topic?.message ?? "")) { item in
                        dispatch(TopicState.Action.loadTopics(itemId: ""))
                        dispatch(TopicState.Action.loadTopic(id: id))

                    }
                }
                
                if case TopicState.Action.removeTopic(let id) = action {
                    let service = ItemListService()
                    service.removeTopic(id: id)
                    dispatch(TopicState.Action.loadTopics(itemId: ""))
                }
                
                if case TopicState.Action.loadTopic(let id) = action {
                    
                    let service = ItemListService()
                    service.loadTopic(uuid: id) { topic in
                        service.loadServer(uuid: topic?.serverUUID ?? "", finished: { serverResult in
                            let topicViewModel = topic.map { _ in
                                Topic(id: topic?.uuid ?? "", name: topic?.name ?? "", topic: topic?.topic ?? "", value: topic?.value ?? "", time: topic?.time ?? "", serverId: topic?.serverUUID ?? "", type: topic?.kind ?? "" , qos: "2", message: topic?.message ?? "")}
                            let server = serverResult.map { Server(id: $0.uuid, name: $0.name, url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort) }
                            dispatch(TopicState.Action.fetchTopic(topic: topicViewModel))
                            dispatch(ServerState.Action.loadServer(id: topic?.serverUUID ?? ""))
                        })
                    }
                    dispatch(TopicState.Action.loadTopics(itemId: ""))
                }
                
                if case TopicState.Action.updateTopic(let item) = action {
                    guard let item = item else { return }
                    let topic = ItemListService.TopicData(uuid: item.id , name: item.name, value: item.value, serverUUID: item.serverId, kind: item.type, topic: item.topic, time: item.time, message: item.message)
                    let service = ItemListService()
                    service.updateTopic(topic: topic) { id in
                        dispatch(TopicState.Action.loadTopic(id: id))
                    }
                }
                
                if case TopicState.Action.removeConnection(let id) = action {
                    
                    let state = getState()?.topicState ?? TopicState()
                    var topicViewModel = state.topic
                    topicViewModel?.serverId = ""
                    dispatch(TopicState.Action.updateTopic(topic: topicViewModel))
                }
                
                if case Action.loadTopics(let itemId) = action {
                    let service = ItemListService()
                    service.loadTopics { topics in
                        let topics = topics.map {
                            Topic(id: $0.uuid, name: $0.name, topic: $0.topic, value: $0.value, time: $0.time, serverId: $0.serverUUID, type: $0.kind, qos: "0", message: $0.message)
                        }
                        
                        topics.forEach {
                            dispatch(TopicState.Action.updateTask(topic: $0))
                        }
                        
                        dispatch(TopicState.Action.fetchTopics(topics: topics))
                        
                    }
                }
                
                if case Action.updateTask(let topic) = action {
                    let service = ItemListService()
                    service.loadServer(uuid: topic.serverId) { configuration in
                        let server = configuration.map {  Server(id: $0.uuid , name: $0.name , url: $0.url, user: $0.username, password: $0.password, port: $0.port, sslPort: $0.sslPort)
                        }
                        guard let result = server else { return }
                        guard let state = getState()?.topicState else { return }

                        if state.tasks[topic.id] != nil { return }
                        
                        let connector = TopicConnector()
                        connector.configure(topic: topic, server: result)
                        connector.didReceiveMessage = { mqtt, message, id, clientId in
                            print("##message: \(message)")
                           let value = message.string ?? ""
                            if connector.topic.value != value {
                               connector.topic.value = value
                                dispatch(TopicState.Action.updateTopic(topic: connector.topic))
                            }
                        }
                        dispatch(TopicState.Action.fetchTask(topicId: topic.id, task: connector))

                    }
                }

                next(action)
            }
        }
    }
}
