//
//  ItemListAction.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift

struct AddItemAction: Action {
    
//    let item: [Item]
}

struct RemoveItemAction: Action {
    
    let item: [Item]
}

struct AddSensorAction: Action {
    
    //    let item: [Item]
}

struct RemoveSensorAction: Action {
    
    let item: Sensor
}

struct ListItemsAction: Action { }

struct ItemListUpdateItemAction: Action {
    let item: CellViewModel
}

import CocoaMQTT

struct ItemListPublishMQTTAction: Action {
    
    var message: String = "5555"
    var mqtt: CocoaMQTT


    init?(uuid: String) {
        
        
        let itemListService = ItemListService()
        guard let configuration = itemListService.loadLocalConfiguration(uuid: uuid) else { return  nil }
        
        guard let port = UInt16(configuration.port) else { return nil }
        let clientID = "CocoaMQTT-" + configuration.uuid
        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
        mqtt.username = configuration.username
        mqtt.password = configuration.password
        mqtt.keepAlive = 60
        mqtt.autoReconnectTimeInterval = 1
        mqtt.autoReconnect = true
        mqtt.connect()
        
        print("#mqtt connecting UUID5555")
        
        mqtt.didReceiveMessage = { mqtt, message, id in
            
            print("#didReceiveMessageUUID5555: \(message)")
            itemListStore.dispatch(ItemListUpdateFromMQTTAction(uuid: uuid, message: message.string))
            
            // TODO - Update sensor in coredata
//            let itemListService = ItemListService()
//            var sensor = itemListService.getSensor(uuid: "")
//            sensor?.value = ""
//            itemListService.updateSensor(sensor: sensor!)
        }
    }
}
struct ItemListUpdateFromMQTTAction: Action {
    let uuid: String
    let message: String?
}
