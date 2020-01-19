//
//  TopicTypeViewController+.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 1/17/20.
//

import RxDataSources

extension TopicTypeViewController {
    
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
    
    enum SectionItem {
        case selectionItem(viewModel: TopicTypeCell.ViewModel)
    }
    
   
}
