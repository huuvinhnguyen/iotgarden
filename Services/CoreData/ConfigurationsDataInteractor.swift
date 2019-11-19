//
//  ConfigurationsDataInteractor.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//
import CoreData

struct ConfigurationsDataInteractor: DataInteractor {
    
    
    typealias MappingData = ItemListService.Configuration
    
    func add(item: MappingData, finished: (MappingData) -> ()) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "LocalConfiguration", in: context)!
        let localConfiguration = NSManagedObject(entity: entity, insertInto: context)
        localConfiguration.setValue(item.uuid, forKeyPath: "uuid")
        localConfiguration.setValue(item.name, forKeyPath: "name")
        localConfiguration.setValue(item.server, forKeyPath: "server")
        localConfiguration.setValue(item.username, forKeyPath: "username")
        localConfiguration.setValue(item.password, forKeyPath: "password")
        localConfiguration.setValue(item.port, forKeyPath: "port")
        
        do {
            
            finished(item)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func delete(id: String, finished: (String) -> ()) {
        let context = Storage.shared.context
        
        let request: NSFetchRequest<LocalConfiguration> = LocalConfiguration.fetchRequest()
        
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
    
    func update(item: ItemListService.Configuration, finished: (_ id: String)->()) {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<LocalConfiguration> = LocalConfiguration.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", item.uuid)
        
        if let result = try? context.fetch(request) {
            for object in result {
                
                object.setValue(item.uuid, forKeyPath: "uuid")
                object.setValue(item.name, forKeyPath: "name")
                object.setValue(item.server, forKeyPath: "server")
                object.setValue(item.username, forKeyPath: "username")
                object.setValue(item.password, forKeyPath: "password")
                object.setValue(item.port, forKeyPath: "port")
            }
        }
        
        do {
            finished(item.uuid)
            try context.save()
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getItem(uuid: String) -> ItemListService.Configuration? {
        
        let context = Storage.shared.context
        
        let request: NSFetchRequest<LocalConfiguration> = LocalConfiguration.fetchRequest()
        request.predicate = NSPredicate.init(format: "uuid == %@", uuid)
        
        if let result = try? context.fetch(request) {
            
            for object in result {
                
                return ItemListService.Configuration(uuid: String(describing: object.value(forKeyPath: "uuid") ?? ""), name: String(describing: object.value(forKeyPath: "name") ?? ""),
                                     server: String(describing: object.value(forKeyPath: "server") ?? ""),
                                     username: String(describing: object.value(forKeyPath: "username") ?? ""),
                                     password: String(describing: object.value(forKeyPath: "password") ?? ""),
                                     port: String(describing: object.value(forKeyPath: "port") ?? ""))
            }
        }
        
        return nil
    }
    
    func getItems(finished: (_ items: [MappingData]) ->()) {
        let context = Storage.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LocalConfiguration")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let items = result.compactMap {
                
                
                ItemListService.Configuration(uuid: String(describing: $0.value(forKeyPath: "uuid") ?? ""), name: String(describing: $0.value(forKeyPath: "name") ?? ""),
                                              server: String(describing: $0.value(forKeyPath: "server") ?? ""),
                                              username: String(describing: $0.value(forKeyPath: "username") ?? ""),
                                              password: String(describing: $0.value(forKeyPath: "password") ?? ""),
                                              port: String(describing: $0.value(forKeyPath: "port") ?? ""))
            }
            
            finished(items)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}
