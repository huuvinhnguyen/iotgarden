//
//  ItemDetailState.swift
//  IoTGarden
//
//  Created by Apple on 6/17/19.
//

import ReSwift

struct ItemDetailState: StateType, Identifiable {
    
    var identifiableComponent = IdentifiableComponent()
    
    var name = ""
    var value = ""
    var kind = ""
    var topic = ""
    var time = ""
}
