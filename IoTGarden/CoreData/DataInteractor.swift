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
    func delete(item: MappingData) -> ()
    func update(item: MappingData) -> ()
    func getItem(uuid: String) -> MappingData?
}

struct SensorsDataInteractor : DataInteractor {
    
    func delete(item: MappingData) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        
        request.predicate = NSPredicate.init(format: "uuid == %@", item.uuid)
        
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
    
    typealias MappingData = Sensor
    
    func add(item: MappingData, finished:(_ item: MappingData)->()) {
        
        let context = Storage.shared.context
        
        let entity = NSEntityDescription.entity(forEntityName: "Sensors", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(item.name, forKeyPath: "name")
        
        localItem.setValue(item.uuid, forKeyPath: "uuid")
        
        localItem.setValue(item.serverUUID, forKeyPath: "serverUUID")
        
        localItem.setValue(item.value, forKeyPath: "value")
        
        localItem.setValue(item.kind, forKeyPath: "kind")
        
        do {
            
            finished(item)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func update(item: MappingData) {
        
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
            }
        }
        
        do {
            
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getItem(uuid: String) -> MappingData? {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Sensors> = Sensors.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                return Sensor(uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""), name: String(describing: object.value(forKeyPath: "name") ?? ""), value:   String(describing:object.value(forKeyPath: "value") ?? "") , serverUUID: String(describing: object.value(forKeyPath: "serverUUID") ?? ""), kind: String(describing: object.value(forKeyPath: "kind") ?? ""))
            }
        }
        
        return nil
    }
    
    func getItems(finished: (_ items: [Sensor]) ->()) {
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sensors")
        
        do {
                        let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {
                
//                            Sensor(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), value:   String(describing:$0.value(forKeyPath: "value") ?? "") , serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""), kind: Kind(rawValue: String(describing: $0.value(forKeyPath: "kind") ?? "toggle"))!)
                Sensor(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), value:   String(describing:$0.value(forKeyPath: "value") ?? "") , serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""), kind: String(describing: $0.value(forKeyPath: "kind") ?? ""))
                        }
            
            finished(items)

            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}
