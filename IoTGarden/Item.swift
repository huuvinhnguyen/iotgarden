//
//  Item.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//
import CocoaMQTT

struct Item {
    
    var uuid: String = ""
    var name: String = ""
    var isOn: Bool? = false
    var serverUUID: String = ""
//    var channel = Channel()
}

struct Channel {
    
    var topic: String = ""
    var message: String = ""
}
