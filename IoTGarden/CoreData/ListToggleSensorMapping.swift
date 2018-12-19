//
//  ListToggleSensorMapping.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import CoreData

struct ListToggleSensorMapping: SensorMapping {
    
    func getItem(uuid: String) -> Item? {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Toggles> = Toggles.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                return ToggleItem(uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""), name: String(describing: object.value(forKeyPath: "name") ?? ""), isOn:  object.value(forKeyPath: "isOn") as? Bool ?? false, serverUUID: String(describing: object.value(forKeyPath: "serverUUID") ?? ""), kind: Kind(rawValue: String(describing: object.value(forKeyPath: "kind") ?? "toggle"))! )
            }
        }
        
        return nil
    }
    
    
    func add(item: Item) {
        
        guard let toggleItem  = item as? ToggleItem else { return }
        let context = Storage.shared.context
        
        let entity = NSEntityDescription.entity(forEntityName: "Toggles", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(toggleItem.name, forKeyPath: "name")
        
        localItem.setValue(toggleItem.uuid, forKeyPath: "uuid")
        
        localItem.setValue(toggleItem.serverUUID, forKeyPath: "serverUUID")
        
        localItem.setValue(toggleItem.isOn, forKeyPath: "isOn")
        
        do {
            
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func update(item: Item) {
        
        guard let toggleItem  = item as? ToggleItem else { return }
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Toggles> = Toggles.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", toggleItem.uuid)
        
        if let result = try? context.fetch(request) {
            for object in result {
                
                object.setValue(toggleItem.name, forKeyPath: "name")
                
                object.setValue(toggleItem.uuid, forKeyPath: "uuid")
                
                object.setValue(toggleItem.serverUUID, forKeyPath: "serverUUID")
                
                object.setValue(toggleItem.isOn, forKeyPath: "isOn")
                
            }
        }
        
        do {
            
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
