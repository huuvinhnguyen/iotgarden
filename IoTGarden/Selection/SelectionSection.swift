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
    case serverItem(viewModel: SelectionServerCell.ViewModel)
    case topicItem(viewModel: Topic)
}

extension SelectionSection: SectionModelType {
    
    typealias Item = SelectionSectionItem
    
    init(original: SelectionSection, items: [Item]) {
        self = original
        self.items = items
    }
}
