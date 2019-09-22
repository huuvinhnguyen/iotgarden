//
//  ConnectionSection.swift
//  Expo
//
//  Created by Vinh Nguyen on 7/29/19.
//  Copyright. All rights reserved.
//
import RxDataSources

struct ConnectionSection {
    
    var title: String
    var items: [Item]
}

extension ConnectionSection: SectionModelType {
    
    typealias Item = ConnectionViewModel
    
    init(original: ConnectionSection, items: [Item]) {
        self = original
        self.items = items
    }
}
