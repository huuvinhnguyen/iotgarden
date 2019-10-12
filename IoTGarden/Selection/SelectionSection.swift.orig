//
//  SelectionSection.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/10/19.
//

import RxDataSources

struct SelectionSection {
    
    var title: String
    var items: [Item]
}

enum SelectionSectionItem {
    case serverItem(viewModel: ServerViewModel)
    case topicItem(viewModel: TopicViewModel)
}

extension SelectionSection: SectionModelType {
    
    typealias Item = SelectionSectionItem
    
    init(original: SelectionSection, items: [Item]) {
        self = original
        self.items = items
    }
}
