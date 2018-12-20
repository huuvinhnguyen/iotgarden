//
//  Item.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//
import CocoaMQTT

protocol Item {
    
    var uuid: String { get set }
    var name: String { get set }
    var serverUUID: String { get set }
    var kind: Kind { get set }
}

struct ToggleItem: Item {
    
    var uuid: String = ""
    var name: String = ""
    var isOn: Bool = false
    var serverUUID: String = ""
    var kind: Kind = .toggle
    //    var channel = Channel()
}


struct Channel {
    
    var topic: String = ""
    var message: String = ""
}
