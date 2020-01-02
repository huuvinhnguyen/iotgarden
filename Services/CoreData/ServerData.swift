//
//  ServerData.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 1/2/20.
//

extension ItemListService {
    
    struct Server {
        
        var uuid: String = ""
        var name: String = ""
        var url: String = ""
        var username: String = ""
        var password: String = ""
        var port: String = ""
        var sslPort: String = ""
    }
    
    func addConfiguration(configuration: Server, finished: (_ id: String)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.add(item: configuration) { _ in
            finished(configuration.uuid)
        }
    }
    
    func updateConfiguration(configuration: Server, finished: (_ id: String)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.update(item: configuration) { _ in
            finished(configuration.uuid)
        }
    }
    
    func loadLocalConfiguration(uuid: String, finished: (_ configuration: Server?)->()) {
        
        let interactor = ConfigurationsDataInteractor()
        interactor.getItem(uuid: uuid) { configuration in
            finished(configuration)
            
        }
    }
    
    func loadConfigures(finished: (_ items: [Server])->()) {
        let interactor = ConfigurationsDataInteractor()
        interactor.getItems { items in
            finished(items)
        }
    }
    
    func deleteConfigure(id: String, finished: (_ id: String)->()) {
        let interactor = ConfigurationsDataInteractor()
        interactor.delete(id: id) { id in
            finished(id)
        }
        
    }
}
