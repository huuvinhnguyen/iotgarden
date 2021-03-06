//
//  TemperatureDevice.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//
import Foundation

class TemperatureDevice: CellViewModel {
    
    
    var sensor: TopicData {
        
        didSet {
            
        }
    }
    var valueString = ""
    var name: String
    var timeString  = ""
    internal var sensorConnect: SensorConnect
    
    init(sensor: TopicData) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
        self.name = sensor.name
        
        configure(sensor: sensor)
    }
    
    func configure(sensor: TopicData) {
        
        sensorConnect.connect(sensor: sensor)
        
        name = sensor.name
        valueString = sensor.value
        timeString = sensor.time
        
        sensorConnect.didReceiveMessage = { [weak self] mqtt, message, id in
            
            var newItem = sensor
            
            guard let weakSelf = self else { return }
            
            print("#Message from  topic \(message.topic) with payload \(message.string!)")
            
            
            weakSelf.valueString = message.string ?? ""
            
            newItem.value = message.string ?? ""
            print("item.name = \(newItem.name)")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let now = Date()
            let dateString = formatter.string(from: now)
            newItem.time =  dateString
            weakSelf.timeString = dateString

            
//            sensorStore.dispatch(UpdateSensorAction(sensor: newItem))
//            let itemListService = ItemListService()
//            itemListService.updateTopic(topic: newItem)
        }
    }
}
