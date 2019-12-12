//
//  ServerSection.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import RxDataSources

struct ServerSection {
    
    var title: String
    var items: [Item]
}

enum ServerSectionItem {
    case serverItem(viewModel: ServerViewModel?)
    case topicItem(viewModel: TopicCell.ViewModel?)
    case topicSwitchItem(viewModel: TopicSwitchViewModel)
    case topicQosItem(viewModel: TopicQosViewModel)
    case topicSaveItem(viewModel: TopicSaveCell.ViewModel)
}

extension ServerSection: SectionModelType {
    
    typealias Item = ServerSectionItem
    
    init(original: ServerSection, items: [Item]) {
        self = original
        self.items = items
    }
}

