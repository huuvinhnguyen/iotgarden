//
//  SwitchCellViewModel.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/20/18.
//
import Foundation
import RxDataSources




class SwitchCellViewModel: CellViewModel, Equatable, IdentifiableType {
    
    var identity: Identity {
        return uuid
    }
    
    typealias Identity = String?
    

    static func == (lhs: SwitchCellViewModel, rhs: SwitchCellViewModel) -> Bool {
        return lhs.isOn == rhs.isOn
    }

    
    var sensor: TopicData {
        
        didSet {
            
        }
    }
    var isOn: Bool = true
    var name: String
    var stateString: String = "Requesting"
    var timeString  = ""
    
    var sensorConnect2: TopicConnector

    internal var sensorConnect: SensorConnect
    
    init(sensor: TopicData) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
        self.sensorConnect2 = TopicConnector()

//        sensorConnect.connect(sensor: sensor)

        self.name = sensor.name
//        configure(sensor: sensor)
    }
    
    func connectSensor() {
//        self.sensorConnect2.connect(sensor: sensor)

    }
    
    private func configure(sensor: TopicData) {
        
        
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
//            sensorStore.dispatch(UpdateSensorAction(sensor: newItem))
            
            if message.string == "done" {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = formatter.string(from: Date())
                newItem.time =  dateString
                weakSelf.timeString = dateString
            }
            
            let itemListService = ItemListService()
//            itemListService.updateTopic(topic: newItem)
        

        }
    }
}

