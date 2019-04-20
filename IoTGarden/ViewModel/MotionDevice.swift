//
//  MotionDevice.swift
//  IoTGarden
//
//  Created by Apple on 2/9/19.
//

import Foundation

class MotionDevice: Device {
    
    var sensor: Sensor
    
    var sensorConnect: SensorConnect
    
    init(sensor: Sensor) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
     
    }
    
}
