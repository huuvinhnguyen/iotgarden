//
//  InputDevice.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 6/8/19.
//

import Foundation

class InputDevice: CellViewModel {
    
    var sensor: Sensor {
        
        didSet {
            
        }
    }
    var isOn: Bool = true
    var name: String
    var stateString: String = "Requesting"
    var timeString  = ""
    
    internal var sensorConnect: SensorConnect
    
    init(sensor: Sensor) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
        sensorConnect.connect(sensor: sensor)
        
        self.name = sensor.name
        configure(sensor: sensor)
    }
    
    private func configure(sensor: Sensor) {
        
        name = sensor.name
        isOn = (sensor.value == "0") ? false : true
        timeString = sensor.time
        
        
        sensorConnect.didReceiveMessage = { [weak self] mqtt, message, id in
            
            var newItem = sensor
            
            guard let weakSelf = self else { return }
            
            print("#Message from  topic \(message.topic) with payload \(message.string!)")
            if message.string == "1" {
                
                weakSelf.isOn = true
            }
            
            if message.string == "0" {
                
                weakSelf.isOn = false
            }
            
            newItem.value = message.string ?? "0"
            print("item.name = \(newItem.name)")
            weakSelf.stateString = "Updated"
            sensorStore.dispatch(UpdateSensorAction(sensor: newItem))
            
            if message.string == "done" {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = formatter.string(from: Date())
                newItem.time =  dateString
                weakSelf.timeString = dateString
            }
            
            let itemListService = ItemListService()
            itemListService.updateSensor(sensor: newItem)
        }
    }
}
