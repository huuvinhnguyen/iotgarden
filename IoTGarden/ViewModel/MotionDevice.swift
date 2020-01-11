//
//  MotionDevice.swift
//  IoTGarden
//
//  Created by Apple on 2/9/19.
//

import Foundation

class MotionDevice: CellViewModel {
    
    var sensor: TopicData
    
    var sensorConnect: SensorConnect
    
    init(sensor: TopicData) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
     
    }
    
}
