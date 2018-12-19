//
//  ListSensorMapping.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import CoreData

struct ListSensorMapping: SensorMapping {
    
    func add(item: Item) {
        
        let context = Storage.shared.context
        
        let entity = NSEntityDescription.entity(forEntityName: "Toggles", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(item.uuid, forKeyPath: "uuid")
        
        localItem.setValue(item.kind, forKeyPath: "kind")
        
        do {
            
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func update(item: Item) {
        
    }
    
    func getItem(uuid: String) -> Item? {
        
        return nil
    }
}
