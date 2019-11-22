//
//  ItemDataInteractor.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/27/19.
//

import CoreData

struct ItemDataInteractor: DataInteractor {
  
    typealias MappingData = ItemListService.ItemData
    
    func add(item: ItemListService.ItemData, finished: (ItemListService.ItemData) -> ()) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Items", in: context)!
        let items = NSManagedObject(entity: entity, insertInto: context)
        items.setValue(item.uuid, forKeyPath: "uuid")
        items.setValue(item.name, forKeyPath: "name")
        items.setValue(item.topics?.joined(separator: ","), forKeyPath: "topics")
        items.setValue(item.imageUrlString, forKeyPath: "imageUrlString")
        
        do {
            
            finished(item)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func update(item: ItemListService.ItemData, finished: (_ id: String) ->()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", item.uuid)
        
        if let result = try? context.fetch(request) {
            let object = result[0] as NSManagedObject
            object.setValue(item.uuid, forKeyPath: "uuid")
            object.setValue(item.name, forKeyPath: "name")
            object.setValue(item.topics?.joined(separator: ","), forKeyPath: "topics")
            object.setValue(item.imageUrlString, forKeyPath: "imageUrlString")
        }
        
        do {
            
            finished(item.uuid)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getItem(uuid: String, finished: (ItemListService.ItemData?) -> ()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                let item =  ItemListService.ItemData(uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""),
                                name: String(describing: object.value(forKeyPath: "name") ?? ""),
                                imageUrlString: String(describing: object.value(forKeyPath: "imageUrlString") ?? ""),
                                topics: [])
                
                finished(item)
                
            }
        }
        
        return finished(nil)
    }
    
    func getItems(finished: (_ items: [ItemListService.ItemData]) ->()) {
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Items")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {
                
              
                ItemListService.ItemData(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""),
                                         name: String(describing: $0.value(forKeyPath: "name") ?? ""),
                                         imageUrlString: String(describing: $0.value(forKeyPath: "imageUrlString") ?? ""),
                                         topics: [])
            }
            
            finished(items)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func delete(id: String, finished: (_ id: String) ->()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        request.predicate = NSPredicate.init(format: "uuid == %@", id)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                print("#delete object")
                context.delete(object)
            }
        }
        
        do {
            finished(id)
            try context.save()
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
