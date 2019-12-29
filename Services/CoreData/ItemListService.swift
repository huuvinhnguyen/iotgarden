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
    
    func loadItem(id: String, finished: (_ item: ItemData?)->()) {
        let interactor = ItemDataInteractor()
        interactor.getItem(uuid: id) { item in
            finished(item)
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
    
    func updateItem(item: ItemData, finished: (_ item: ItemData)->()) {
        let interactor = ItemDataInteractor()
        interactor.update(item: item) { _ in
            finished(item)
        }
        
    }
    
    
    func loadTopics(finished: (_ topics: [TopicToDo])-> ()) {
        
        let interactor = SensorsDataInteractor()
        
        interactor.getItems { topics in
            
            finished(topics)
        }
        
    }
    
    func loadSensors(finished: (_ sensors: [TopicToDo])->()) {
        
//        finished([Sensor(uuid: "abc", name: "abc", value: "aaa", serverUUID: "123", kind: .temperature)])
        
        let interactor = SensorsDataInteractor()
        interactor.getItems { sensors in
            
            finished(sensors)
        }
    }
    
    func addLocalItem(item: Item) {
        
        let sensors = SensorsDataInteractor()
        
        sensors.add(item: TopicToDo()) { _ in }
    }
    
    func addTopic(topic: TopicToDo, finished: (_ id: String)->()) {
        
        let sensors = SensorsDataInteractor()
        sensors.add(item: topic) { _ in
            finished(topic.uuid)
        }
    }
    
    func loadTopic(uuid: String, finished: (TopicToDo?) -> ()) {
        let sensors = SensorsDataInteractor()
        sensors.getItem(uuid: uuid) { topic in
            finished(topic)
        }
    }
    
    func updateTopic(topic: TopicToDo) {
        
        let sensors = SensorsDataInteractor()
        
        sensors.update(item: topic) { id in
            
        }
    }
    
    
    func removeTopic(id: String) {
        
        let sensors = SensorsDataInteractor()
        sensors.delete(id: id) { id in
            
        }
    }
}

extension ItemListService {
    
    struct Server {
        
        var uuid: String = ""
        var name: String = ""
        var url: String = ""
        var username: String = ""
        var password: String = ""
        var port: String = ""
        var sslPort: String = ""
    }
    
    func addConfiguration(configuration: Server, finished: (_ id: String)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.add(item: configuration) { _ in
            finished(configuration.uuid)
        }
    }
    
    func updateConfiguration(configuration: Server, finished: (_ id: String)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.update(item: configuration) { _ in
            finished(configuration.uuid)
        }
    }
    
    func loadLocalConfiguration(uuid: String, finished: (_ configuration: Server?)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.getItem(uuid: uuid) { configuration in
            finished(configuration)
            
        }
    }
    
    func loadConfigures(finished: (_ items: [Server])->()) {
        let interactor = ConfigurationsDataInteractor()
        interactor.getItems { items in
            finished(items)
        }
    }
    
    func deleteConfigure(id: String, finished: (_ id: String)->()) {
        let interactor = ConfigurationsDataInteractor()
        interactor.delete(id: id) { id in
            finished(id)
        }

    }

}
