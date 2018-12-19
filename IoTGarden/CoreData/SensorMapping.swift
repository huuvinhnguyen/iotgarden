//
//  SensorMapping.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import CoreData

protocol  SensorMapping {
    
    func add(item: Item ) -> ()
    func delete(item: Item) -> ()
    func update(item: Item) -> ()
    func getItem(uuid: String) -> Item?
}

extension SensorMapping {
    
    func delete(item: Item) {
        
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
}


protocol A {
    
    associatedtype B
}

struct C: A {
    typealias B = C
}

struct Mapping<T: Item> {
    
    
    fileprivate let _observer: T

    init(item: T) {
        
        _observer = item

        
    }
    func map() -> [T] {
        return []
    }
}
