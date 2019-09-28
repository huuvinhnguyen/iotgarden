//
//  ServerSection.swift
//  IoTGarden
//
//  Created by chuyendo on 9/23/19.
//

import RxDataSources

struct ServerSection {
    
    var title: String
    var items: [Item]
}

enum ServerSectionItem {
    case serverItem(viewModel: ServerViewModel)
    case topicItem(viewModel: TopicViewModel)
    case topicSwitchItem(viewModel: TopicSwitchViewModel)
    case topicQosItem(viewModel: TopicQosViewModel)
}

extension ServerSection: SectionModelType {
    
    typealias Item = ServerSectionItem
    
    init(original: ServerSection, items: [Item]) {
        self = original
        self.items = items
    }
}

