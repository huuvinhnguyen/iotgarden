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
        
        sensors.update(item: sensor) { id in
            
        }
    }
    
    
    func removeTopic(id: String) {
        
        let sensors = SensorsDataInteractor()
        sensors.delete(id: id) { id in
            
        }
    }
}

extension ItemListService {
    
    struct Configuration {
        
        var uuid: String = ""
        var name: String = ""
        var server: String = ""
        var username: String = ""
        var password: String = ""
        var port: String = ""
    }
    
    func addConfiguration(configuration: Configuration, finished: (_ id: String)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.add(item: configuration) { _ in
            finished(configuration.uuid)
        }
    }
    
    func loadLocalConfiguration(uuid: String) -> Configuration? {
        
        let interactor = ConfigurationsDataInteractor()
        return interactor.getItem(uuid: uuid)
    }
    
    func loadConfigures(finished: (_ items: [Configuration])->()) {
        let interactor = ConfigurationsDataInteractor()
        interactor.getItems { items in
            finished(items)
        }
    }
    
    func deleteConfigure(id: String) {
        
    }

}
