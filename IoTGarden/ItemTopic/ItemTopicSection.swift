//
//  ItemTopicSection.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import RxDataSources

protocol SectionItemViewModel {}

enum ItemTopicSection {
    
    case headerSection(items: [ItemTopicSectionItem])
    case topicSection(items: [ItemTopicSectionItem])
    case serverSection(items: [ItemTopicSectionItem])
    case footerSection(items: [ItemTopicSectionItem])
}

enum ItemTopicSectionItem {
    
    case headerItem(viewModel: SectionItemViewModel?)
    case topicItem(viewModel: TopicViewModel)
    case serverItem(viewModel: ConnectionViewModel)
    case footerItem(viewModel: SectionItemViewModel?)
}

extension ItemTopicSection: SectionModelType {
    typealias Item = ItemTopicSectionItem
    
    var items: [Item] {
        switch self {
        case .headerSection(items: let items):
            return items
        case .topicSection(items: let items):
            return items
        case .serverSection(items: let items):
            return items
        case .footerSection(items: let items):
            return items
        }
    }
    
    init(original: ItemTopicSection, items: [Item]) {
        switch original {
        case let .headerSection(items):
            self = .headerSection(items: items)
        case let .topicSection(items):
            self = .topicSection(items: items)
        case let .serverSection(items):
            self = .serverSection(items: items)
        case let .footerSection(items):
            self = .footerSection(items: items)
        }
    }
}
