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
    
    typealias MappingData = TopicToDo
    
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
                
                object.setValue(item.topic, forKeyPath: "topic")
                
                object.setValue(item.time, forKeyPath: "time")


            }
        }
        
        do {
            
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
                
                let topic =  TopicToDo(
                    uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""),
                              name: String(describing: object.value(forKeyPath: "name") ?? ""),
                              value:   String(describing:object.value(forKeyPath: "value") ?? "") ,
                              serverUUID: String(describing: object.value(forKeyPath: "serverUUID") ?? ""),
                              kind: String(describing: object.value(forKeyPath: "kind") ?? ""),
                              topic: String(describing: object.value(forKeyPath: "topic") ?? ""),
                              time: String(describing: object.value(forKeyPath: "time") ?? ""))
                finished(topic)
                return
            }
        }
        
        finished(nil)
    }
    
    func getItems(finished: (_ items: [TopicToDo]) ->()) {
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensors")
        
        do {
                        let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {
                
//                            Sensor(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), value:   String(describing:$0.value(forKeyPath: "value") ?? "") , serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""), kind: Kind(rawValue: String(describing: $0.value(forKeyPath: "kind") ?? "toggle"))!)
                TopicToDo(uuid:
                    String(describing: $0.value(forKeyPath: "uuid") ?? ""),
                       name: String(describing: $0.value(forKeyPath: "name") ?? ""),
                       value:   String(describing:$0.value(forKeyPath: "value") ?? "") ,
                       serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""),
                       kind: String(describing: $0.value(forKeyPath: "kind") ?? ""),
                       topic: String(describing: $0.value(forKeyPath: "topic") ?? ""),
                    time: String(describing: $0.value(forKeyPath: "time") ?? "")

                )
                        }
            
            finished(items)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
