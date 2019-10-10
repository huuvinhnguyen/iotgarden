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

extension SelectionSection: SectionModelType {
    
    typealias Item = SelectionViewModel
    
    init(original: SelectionSection, items: [Item]) {
        self = original
        self.items = items
    }
}
