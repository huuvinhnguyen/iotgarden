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
    
    func loadItems(finished: @escaping (_ items: [Item])->()) {
        
        loadLocalItems1().done { items in
            
            var newItems = [Item]()
            
            let  promisedList = items.map { self.fetchItemState(item: $0) }
            when(resolved: promisedList).done { results in
                results.forEach {
                    
                    switch $0 {
                    case .fulfilled(let value):
                    newItems.append(value)
                    case .rejected(let error):
                        ()
                    }
                }
                
                print("#newItems2 count: \(newItems.count)")
                finished(newItems)
            }
        }
    }
    
    func loadLocalItems1()-> Promise<[Item]> {
        
        return Promise { seal in
            
            let context = Storage.shared.context
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
            
            do {
                
                let result = try context.fetch(fetchRequest)
                
                let items = result.compactMap {
                    
                    Item(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), isOn: true, serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""))
                }
                
                seal.fulfill(items)
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                seal.reject(error)
            }
        }
    }
    
 
    
    func loadLocalItems(finished: (_ items: [Item])->()) {
        
        loadItems { items in
            print("#local items: \(items.count)")
        }
        
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        
        do {
            
            let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {

                Item(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""), isOn: true, serverUUID: String(describing: $0.value(forKeyPath: "serverUUID") ?? ""))
            }
            
            finished(items)
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchedItems(items: [Item]) -> Promise<[Item]>{
        
        return Promise { seal in
            
            var newItems = [Item]()

            _ = items.map {
                
                fetchItemState(item: $0).done { newItem in
                    print("#promised item added")
                    newItems.append(newItem)
                }
            }
            print("#fetched newItems count:\(newItems.count)")

            seal.fulfill(newItems)

        }
    }

    
    func fetchItemState(item: Item) -> Promise<Item>  {
        
        return Promise { seal in
            
            var copyItem = item
            let itemConect = ItemConnect()
            itemConect.connect(item: item)
            itemConect.didReceiveMessage = { mqtt, message, id in
                 
                print("#Item: \(copyItem.name)")
                copyItem.isOn = message.string == "1" ? true : false
                seal.fulfill(copyItem)
            }
        }
    }
    
    func addLocalItem(item: Item) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "List", in: context)!
        
        let localItem = NSManagedObject(entity: entity, insertInto: context)
        
        localItem.setValue(item.name, forKeyPath: "name")
        
        localItem.setValue(item.serverUUID, forKeyPath: "uuid")
        
        localItem.setValue(item.serverUUID, forKeyPath: "serverUUID")
        
        localItem.setValue(item.isOn, forKeyPath: "isOn")

        do {
            
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateItem(item: Item) {
        let context = Storage.shared.context
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", item.uuid)
        
        if let result = try? context.fetch(request) {
            for object in result {
                
                object.setValue(item.name, forKeyPath: "name")
                
                object.setValue(item.serverUUID, forKeyPath: "uuid")
                
                object.setValue(item.serverUUID, forKeyPath: "serverUUID")
                
                object.setValue(item.isOn, forKeyPath: "isOn")
                
            }
            
        }
        
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
    
    func addLocalConfiguration(configuration: Configuration) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "LocalConfiguration", in: context)!
        let localConfiguration = NSManagedObject(entity: entity, insertInto: context)
        localConfiguration.setValue(configuration.uuid, forKeyPath: "uuid")
        localConfiguration.setValue(configuration.server, forKeyPath: "server")
        localConfiguration.setValue(configuration.username, forKeyPath: "username")
        localConfiguration.setValue(configuration.password, forKeyPath: "password")
        localConfiguration.setValue(configuration.port, forKeyPath: "port")
        
        do {
            
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadLocalConfiguration(username: String) {
        
    }
    
    func loadLocalConfiguration(uuid: String) -> Configuration? {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<LocalConfiguration> = LocalConfiguration.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
                for object in result {
                    
                    return Configuration(uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""),
                                         server: String(describing: object.value(forKeyPath: "server") ?? ""),
                                         username: String(describing: object.value(forKeyPath: "username") ?? ""),
                                         password: String(describing: object.value(forKeyPath: "password") ?? ""),
                                         port: String(describing: object.value(forKeyPath: "port") ?? ""))
                }
        }
        
        return nil
    }
}
