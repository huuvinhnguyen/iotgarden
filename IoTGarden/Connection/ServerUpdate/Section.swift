//
//  ServerSection.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import RxDataSources

extension ServerViewController {
    
    enum SectionItem {
        case serverItem(viewModel: ServerCell.ViewModel?)
        case topicItem(viewModel: TopicCell.ViewModel?)
        case topicSwitchItem(viewModel: TopicSwitchViewModel)
        case topicQosItem(viewModel: TopicQosViewModel)
        case topicSaveItem(viewModel: TopicSaveCell.ViewModel)
        case trashItem(id: String)
    }
    
    struct Section: SectionModelType {
        
        var title: String
        var items: [Item]
        typealias Item = SectionItem
        
        init(title: String, items: [Item]) {
            self.title = title
            self.items = items
        }
        
        init(original: Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
}
