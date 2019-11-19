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
    var topicViewModel = TopicViewModel()
    var connectionViewModel = ConnectionViewModel(id:"", name: "hvm server", server: "https//icloud.com/", title: "", isSelected: true)
}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics()
        case loadConection()
        case addTopic()
        case removeTopic(id: String)
        case loadTopic(id: String)
        case loadConnection(id: String)
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
            
        case .loadTopic(let id):
            state.topicViewModel = TopicViewModel(id:"", name: "light livi", topic: "switchab", value: "1", time: "22/12/2019", connectionId: "", type: "switch")
            state.identifiableComponent.update()
            
        case .loadConnection(let id):
            state.connectionViewModel = ConnectionViewModel(id: "", name: "icloud server", server: "https://coulds.com", title: "tr", isSelected: true)
            state.identifiableComponent.update()
            
        default: ()

        }
        
        return state

    }
}
