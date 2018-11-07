//
//  ItemListService.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//
import CoreData
import ReactiveReSwift

struct ItemListService {
    
    func loadLocalItems() -> [Item] {
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        
        do {
            
            let localItemList = try context.fetch(fetchRequest)
            
            let items = localItemList.compactMap {

                Item(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), isOn: true)
            }
            
            return items
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func addLocalItem(item: Item) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "List", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(item.name, forKeyPath: "name")
        
        localItem.setValue(UUID().uuidString, forKeyPath: "uuid")
        
        
        do {
            
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeLocalItem(uuid: String) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
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
