//
//  AddItemTopicSection.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/18/19.
//

import RxDataSources

struct AddItemTopicSection {
    
    var title: String
    var items: [Item]
}

extension AddItemTopicSection: SectionModelType {
    
    typealias Item = AddItemTopicViewModel
    
    init(original: AddItemTopicSection, items: [Item]) {
        self = original
        self.items = items
    }
}
