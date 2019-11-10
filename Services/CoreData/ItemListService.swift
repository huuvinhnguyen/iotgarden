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
    
    struct ItemData {
        let uuid: String
        let name: String
        let imageUrlString: String
        var topics: [String]?
    }
    
    func loadItems(finished: (_ items: [ItemData])->()) {
        let interactor = ItemDataInteractor()
        interactor.getItems { items in
            finished(items)
        }
    }
    
    func addItem(item: ItemData, finished: (_ item: ItemData)->()) {
        let interactor = ItemDataInteractor()
        interactor.add(item: item) { itemData in
            finished(itemData)
        }
    }
    
    func removeItem(id: String, finished: (_ id: String)->()) {
        let interactor = ItemDataInteractor()
        interactor.delete(id: id) { finished($0) }
        
    }
    
    
    func loadTopics(finished: (_ topics: [Topic])-> ()) {
        
        let interactor = SensorsDataInteractor()
        
        interactor.getItems { topics in
            
            finished(topics)
        }
        
    }
    
    func loadSensors(finished: (_ sensors: [Topic])->()) {
        
//        finished([Sensor(uuid: "abc", name: "abc", value: "aaa", serverUUID: "123", kind: .temperature)])
        
        let interactor = SensorsDataInteractor()
        interactor.getItems { sensors in
            
            finished(sensors)
        }
    }
    
    func addLocalItem(item: Item) {
        
        let sensors = SensorsDataInteractor()
        
        sensors.add(item: Topic()) { _ in }
    }
    
    func addTopic(topic: Topic, finished: (_ id: String)->()) {
        
        let sensors = SensorsDataInteractor()
        sensors.add(item: topic) { _ in
            finished(topic.uuid)
        }
    }
    
    func getSensor(uuid: String) -> Topic? {
        let sensors = SensorsDataInteractor()
        return sensors.getItem(uuid: uuid)
    }
    
    func updateSensor(sensor: Topic) {
        
        let sensors = SensorsDataInteractor()
        sensors.update(item: sensor)
    }
    
    
    func removeTopic(id: String) {
        
        let sensors = SensorsDataInteractor()
        sensors.delete(id: id) { id in
            
        }
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
