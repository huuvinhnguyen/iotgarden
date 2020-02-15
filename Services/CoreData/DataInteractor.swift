//
//  DataInteractor.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import CoreData

protocol  DataInteractor {
    
    associatedtype MappingData
    
    func add(item: MappingData, finished:(_ item: MappingData)->()) -> ()
    func delete(id: String, finished: (_ id: String)->()) -> ()
    func update(item: MappingData, finished: (_ id: String)->()) -> ()
    func getItem(uuid: String, finished: (MappingData?) -> ())
}

struct SensorsDataInteractor : DataInteractor {
   
    
    func delete(id: String, finished: (String) -> ()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        
        request.predicate = NSPredicate.init(format: "uuid == %@", id)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                print("#delete object")
                context.delete(object)
            }
        }
        
        do {
            
            try context.save()
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTopics(itemId: String, finished: (String) -> ()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        
        request.predicate = NSPredicate.init(format: "itemId == %@", itemId)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                print("#delete all object")
                context.delete(object)
            }
        }
        
        do {
            
            finished(itemId)
            try context.save()
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    typealias MappingData = ItemListService.TopicData
    
    func add(item: MappingData, finished:(_ item: MappingData)->()) {
        
        let context = Storage.shared.context
        
        let entity = NSEntityDescription.entity(forEntityName: "Sensors", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(item.name, forKeyPath: "name")
        
        localItem.setValue(item.uuid, forKeyPath: "uuid")
        
        localItem.setValue(item.serverUUID, forKeyPath: "serverUUID")
        
        localItem.setValue(item.value, forKeyPath: "value")
        
        localItem.setValue(item.kind, forKeyPath: "kind")
        
        localItem.setValue(item.topic, forKeyPath: "topic")
        
        localItem.setValue(item.time, forKeyPath: "time")
        
        localItem.setValue(item.message, forKeyPath: "message")
        
        localItem.setValue(Date(), forKeyPath: "date")
        
        localItem.setValue(item.retain, forKeyPath: "retained")
        
        localItem.setValue(item.itemId, forKeyPath: "itemId")

        do {
            
            finished(item)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func update(item: MappingData, finished: (_ id: String)->()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", item.uuid)
        
        if let result = try? context.fetch(request) {
            for object in result {
                
                object.setValue(item.name, forKeyPath: "name")
                
                object.setValue(item.uuid, forKeyPath: "uuid")
                
                object.setValue(item.serverUUID, forKeyPath: "serverUUID")
                
                object.setValue(item.value, forKeyPath: "value")
                
                object.setValue(item.kind, forKeyPath: "kind")
                
                object.setValue(item.qos, forKeyPath: "qos")
                
                object.setValue(item.topic, forKeyPath: "topic")
                
                object.setValue(item.time, forKeyPath: "time")
                
                object.setValue(item.message, forKeyPath: "message")
                
                object.setValue(item.retain, forKeyPath: "retained")
                
                object.setValue(item.itemId, forKeyPath: "itemId")


            }
        }
        
        do {
            finished(item.uuid)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getItem(uuid: String, finished: (_ id: MappingData?)->()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                let topic =  ItemListService.TopicData(
                    uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""),
                              name: String(describing: object.value(forKeyPath: "name") ?? ""),
                              value:   String(describing:object.value(forKeyPath: "value") ?? "") ,
                              serverUUID: String(describing: object.value(forKeyPath: "serverUUID") ?? ""),
                              kind: String(describing: object.value(forKeyPath: "kind") ?? ""),
                              qos: String(describing: object.value(forKeyPath: "qos") ?? ""),
                              topic: String(describing: object.value(forKeyPath: "topic") ?? ""),
                              time: String(describing: object.value(forKeyPath: "time") ?? ""),
                              message: String(describing: object.value(forKeyPath: "message") ?? ""),
                              retain: String(describing: object.value(forKeyPath: "retained") ?? ""),
                              itemId: String(describing: object.value(forKeyPath: "itemId") ?? "")
                )
                finished(topic)
                return
            }
        }
        
        finished(nil)
    }
    
    func getItems(itemId: String, finished: (_ items: [ItemListService.TopicData]) ->()) {
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensors")
        fetchRequest.predicate = NSPredicate.init(format: "itemId == %@", itemId)

        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        let sortDescriptors = [sort]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
                        let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {
                
                ItemListService.TopicData(uuid:
                    String(describing: $0.value(forKeyPath: "uuid") ?? ""),
                       name: String(describing: $0.value(forKeyPath: "name") ?? ""),
                       value:   String(describing:$0.value(forKeyPath: "value") ?? "") ,
                       serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""),
                       kind: String(describing: $0.value(forKeyPath: "kind") ?? ""),
                       qos: String(describing: $0.value(forKeyPath: "qos") ?? ""),
                       topic: String(describing: $0.value(forKeyPath: "topic") ?? ""),
                    time: String(describing: $0.value(forKeyPath: "time") ?? ""),
                    message: String(describing: $0.value(forKeyPath: "message") ?? ""),
                    retain: String(describing: $0.value(forKeyPath: "retained") ?? ""),
                    itemId: String(describing: $0.value(forKeyPath: "itemId") ?? "")

                )
                        }
            
            finished(items)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
