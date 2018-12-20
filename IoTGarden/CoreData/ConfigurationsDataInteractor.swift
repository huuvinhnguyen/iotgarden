//
//  ConfigurationsDataInteractor.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//
import CoreData

struct ConfigurationsDataInteractor: DataInteractor {
    
    typealias MappingData = Configuration
    
    func add(item: Configuration, finished: (Configuration) -> ()) {
        
        let context = Storage.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "LocalConfiguration", in: context)!
        let localConfiguration = NSManagedObject(entity: entity, insertInto: context)
        localConfiguration.setValue(item.uuid, forKeyPath: "uuid")
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
    
    func delete(item: Configuration) {
        
    }
    
    func update(item: Configuration) {
        
    }
    
    func getItem(uuid: String) -> Configuration? {
        
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
