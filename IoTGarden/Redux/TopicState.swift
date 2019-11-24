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
    var serverViewModel: ServerViewModel?
}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics()
        case loadConection()
        case addTopic(viewModel: TopicViewModel?)
        case removeTopic(id: String)
        case loadTopic(id: String)
        case loadConnection(id: String)
        case fetchTopic(topicViewModel: TopicViewModel?, serverViewModel: ServerViewModel?)
        case updateTopic(topicViewModel: TopicViewModel?)
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
                   TopicViewModel(id: $0.uuid, name: $0.name, topic: "switchab", value: "1", time: "22/12/2019", connectionId: "", type: "Switch")
                }
            }
            state.identifiableComponent.update()
            
        
        case .loadConnection(let id):
            let service = ItemListService()
            service.loadLocalConfiguration(uuid: id) { configuration in
                let viewModel = configuration.map {  ServerViewModel(id: $0.uuid , name: $0.name , url: $0.server )
                    } ?? ServerViewModel(id: "", name: "", url: "")
                
                state.serverViewModel = viewModel
                state.identifiableComponent.update()

            }
//                ConnectionViewModel(id: "", name: "icloud server", server: "https://coulds.com", title: "tr", isSelected: true)
            
        case .fetchTopic(let topicViewModel, let serverViewMode):
            state.topicViewModel = topicViewModel
            state.serverViewModel = serverViewMode
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
                    service.addTopic(topic: Topic(uuid: UUID().uuidString, name: viewModel?.name ?? "", value: "0", serverUUID: viewModel?.connectionId ?? "", kind: "kind", topic: "topic", time: "waiting")) { item in
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
                                TopicViewModel(id: topic?.uuid ?? "", name: topic?.name ?? "", topic: "", value: topic?.value ?? "", time: "", connectionId: topic?.serverUUID ?? "", type: "switch" )}
                            let serverViewModel = configuration.map { ServerViewModel(id: $0.uuid, name: $0.name, url: $0.server) }
                            dispatch(TopicState.Action.fetchTopic(topicViewModel: topicViewModel, serverViewModel: serverViewModel))
                        })
                    }
                    dispatch(TopicState.Action.loadTopics())
                }
                
                if case TopicState.Action.updateTopic(let item) = action {
                    guard let item = item else { return }
                    let service = ItemListService()
                    service.updateTopic(topic: Topic(uuid: item.id , name: item.name, value: "1", serverUUID: item.connectionId, kind: "", topic: "", time: ""))
                    dispatch(TopicState.Action.loadTopic(id: item.id))
                }

                next(action)
            }
        }
    }
}
