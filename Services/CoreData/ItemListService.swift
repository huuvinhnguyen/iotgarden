//
//  ItemListService.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//
import CoreData
import ReactiveReSwift
import PromiseKit

struct ItemListService {
    
    func loadSensors(finished: (_ sensors: [Sensor])->()) {
        
//        finished([Sensor(uuid: "abc", name: "abc", value: "aaa", serverUUID: "123", kind: .temperature)])
        
        let interactor = SensorsDataInteractor()
        interactor.getItems { sensors in
            
            finished(sensors)
        }
    }
    
    func addLocalItem(item: Item) {
        
        let sensors = SensorsDataInteractor()
        
        sensors.add(item: Sensor()) { _ in }
    }
    
    func addSensor(sensor: Sensor) {
        
        let sensors = SensorsDataInteractor()
        sensors.add(item: sensor) { _ in }
    }
    
    func getSensor(uuid: String) -> Sensor? {
        let sensors = SensorsDataInteractor()
        return sensors.getItem(uuid: uuid)

    }
    
    
    func updateSensor(sensor: Sensor) {
        
        let sensors = SensorsDataInteractor()
        sensors.update(item: sensor)
    }
    
    
    func removeSensor(sensor: Sensor) {
        
        let sensors = SensorsDataInteractor()
        sensors.delete(item: sensor)
    }
    
    func addLocalConfiguration(configuration: Configuration) {
        
        let configurations = ConfigurationsDataInteractor()
        configurations.add(item: configuration) { _ in}
    }
    
    func loadLocalConfiguration(uuid: String) -> Configuration? {
        
        let configurations = ConfigurationsDataInteractor()
        return configurations.getItem(uuid: uuid)
    }
}
