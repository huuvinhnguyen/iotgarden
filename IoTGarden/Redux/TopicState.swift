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
    var topicViewModel = TopicViewModel()
    var connectionViewModel = ConnectionViewModel(id:"", name: "hvm server", server: "https//icloud.com/", title: "", isSelected: true)
}


extension TopicState {
    enum Action: ReSwift.Action {
        case loadTopics()
        case loadCoonection()
        case addTopic()
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
            let sections: [ItemDetailSectionModel] = [
                .headerSection(items: [.headerItem(viewModel: ItemDetailHeaderViewModel(name: "Header AAA"))]),
                .topicSection(items: [
                    .topicItem(viewModel: ItemDetailTopicViewModel(name: "Topic switch", value: "ON", updated: "25-08-2019", type: "Switch")),
                    .topicItem(viewModel: ItemDetailTopicViewModel(name: "Topic switch", value: "ON", updated: "25-08-2019", type: "Normal"))
                    ]),
                
                .footerSection(items: [
                    .footerItem(viewModel: ItemDetailFooterViewModel(kind: "plus")),
                    .footerItem(viewModel: ItemDetailFooterViewModel(kind: "trash"))
                    ])
            ]
            
            state.topicItems = sections
            state.identifiableComponent.update()
            
        case .loadTopic(let id):
            state.topicViewModel = TopicViewModel(id:"", name: "light livi", topic: "switchab", value: "1", time: "22/12/2019", connectionId: "")
            state.identifiableComponent.update()
            
        case .loadConnection(let id):
            state.connectionViewModel = ConnectionViewModel(id: "", name: "icloud server", server: "https://coulds.com", title: "tr", isSelected: true)
            state.identifiableComponent.update()
            
        default: ()

        }
        
        return state

    }
}
