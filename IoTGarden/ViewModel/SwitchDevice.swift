//
//  SwitchDevice.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

class SwitchDevice: Device {
    
    var sensor: Sensor {
        
        didSet {
            
        }
    }
    var isOn: Bool = true
    var name: String
    internal var sensorConnect: SensorConnect
    
    init(sensor: Sensor) {
        
        self.sensor = sensor
        self.sensorConnect = SensorConnect()
        self.name = sensor.name
        configure(sensor: sensor)
    }
    
    func configure(sensor: Sensor) {
        
        sensorConnect.connect(sensor: sensor)
        
        name = sensor.name
        isOn = (sensor.value == "0") ? false : true
        
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
            sensorStore.dispatch(UpdateSensorAction(sensor: newItem))
            let itemListService = ItemListService()
            itemListService.updateSensor(sensor: newItem)
        }
    }
}
