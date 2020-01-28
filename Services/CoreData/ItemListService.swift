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
    
    struct TopicData {
        
        var uuid: String = ""
        
        var name: String = ""
        
        var value: String = ""
        
        var serverUUID: String = ""
        
        var kind: String = ""
        
        var qos: String = ""
        
        var topic: String = ""
        
        var time: String = ""
        
        var message: String = ""
        
        var retain: String = ""
        
        var itemId: String = ""
    }
    
    func loadTopics(itemId: String, finished: (_ topics: [ItemListService.TopicData])-> ()) {
        
        let interactor = SensorsDataInteractor()
        
        interactor.getItems(itemId: itemId) { topics in
            
            finished(topics)
        }
        
    }
    
    func addTopic(topic: ItemListService.TopicData, finished: (_ id: String)->()) {
        
        let sensors = SensorsDataInteractor()
        sensors.add(item: topic) { _ in
            finished(topic.uuid)
        }
    }
    
    func loadTopic(uuid: String, finished: (ItemListService.TopicData?) -> ()) {
        let sensors = SensorsDataInteractor()
        sensors.getItem(uuid: uuid) { topic in
            finished(topic)
        }
    }
    
    func updateTopic(topic: ItemListService.TopicData, finished: (_ id: String) -> ()) {
        
        let sensors = SensorsDataInteractor()
        
        sensors.update(item: topic) { id in
            finished(id)
        }
    }
    
    
    func removeTopic(id: String) {
        
        let sensors = SensorsDataInteractor()
        sensors.delete(id: id) { id in
            
        }
    }
}
