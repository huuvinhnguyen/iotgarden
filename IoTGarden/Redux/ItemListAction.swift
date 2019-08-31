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

struct ListItemsAction2: Action { }


struct ItemListUpdateItemAction: Action {
    let item: CellViewModel
}

import CocoaMQTT

struct ItemListPublishMQTTAction: Action {
    
    var message: String? = ""
    var mqtt: CocoaMQTT?
    var sensorConnect = SensorConnect2()


    init(sensor: Sensor) {
//        print("#mqtt sensorConnect 5555")
//
        sensorConnect.connect(sensor: sensor)
//
//
//        let itemListService = ItemListService()
//        guard let configuration = itemListService.loadLocalConfiguration(uuid: sensor.serverUUID) else { return   }
//
//        guard let port = UInt16(configuration.port) else { return  }
//        let clientID = "CocoaMQTT-" + configuration.uuid
//        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
//        guard let mqtt = mqtt else { return }
//        mqtt.username = configuration.username
//        mqtt.password = configuration.password
//        mqtt.keepAlive = 60
//        mqtt.autoReconnectTimeInterval = 1
//        mqtt.autoReconnect = true
//        mqtt.connect()

        print("#mqtt connecting UUID5555")

//        mqtt.didReceiveMessage = { mqtt, message, id in
//
//            print("#didReceiveMessageUUID5555: \(message)")
//            itemListStore.dispatch(ItemListUpdateFromMQTTAction(uuid: sensor.uuid, message: ""))
//
//            // TODO - Update sensor in coredata
////            let itemListService = ItemListService()
////            var sensor = itemListService.getSensor(uuid: "")
////            sensor?.value = ""
//            itemListService.updateSensor(sensor: sensor!)
//        }
    }
}
struct ItemListUpdateFromMQTTAction: Action {
    let uuid: String
    let message: String?
}
