//
//  HumidityDevice.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

class HumidityDevice: Device {
    
    var sensor: Sensor {
        
        didSet {
            
        }
    }
    var valueString = ""
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
        valueString = sensor.value
        
        sensorConnect.didReceiveMessage = { [weak self] mqtt, message, id in
            
            var newItem = sensor
            
            guard let weakSelf = self else { return }
            
            print("#Message from  topic \(message.topic) with payload \(message.string!)")
         
            
            weakSelf.valueString = message.string ?? ""
            
            newItem.value = message.string ?? ""
            print("item.name = \(newItem.name)")
            sensorStore.dispatch(UpdateSensorAction(sensor: newItem))
            let itemListService = ItemListService()
            itemListService.updateSensor(sensor: newItem)
        }
    }
}
