//
//  MotionDevice.swift
//  IoTGarden
//
//  Created by Apple on 2/9/19.
//

import Foundation

class MotionDevice: CellViewModel {
    
    var sensor: TopicToDo
    
    var sensorConnect: SensorConnect
    
    init(sensor: TopicToDo) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
     
    }
    
}
