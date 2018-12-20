//
//  Device.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

enum Kind: String, EnumCollection {
    
    case temperature = "temperature"
    case humidity = "humidity"
    case toggle = "toggle"
}

protocol Device {
    
    var sensor: Sensor { get set }
    var sensorConnect: SensorConnect { get set }
}

protocol Display {
    
    func display(device: Device)
}
