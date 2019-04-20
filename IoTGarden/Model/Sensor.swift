//
//  Sensor.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import Foundation

struct Sensor {
    
    var uuid: String = ""
    
    var name: String = ""
    
    var value: String = ""
    
    var serverUUID: String = ""
    
    var kind: String = ""
    
    var topic: String = ""
    
    var time: String = ""
}

struct SensorValue {
    
    var value: String = ""
    
    var time: String = ""
}
