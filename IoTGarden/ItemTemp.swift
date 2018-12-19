//
//  ItemTemp.swift
//  IoTGarden
//
//  Created by Apple on 12/14/18.
//


struct ItemTemp: Item {
    
    var uuid: String = ""
    
    var name: String = ""
    
    var serverUUID: String = ""
    
    var temp = 25
    
    var kind: Kind = .temperature
}

struct ItemTempViewModel {
    
}
