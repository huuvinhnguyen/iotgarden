//
//  SensorConnect2.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import CocoaMQTT

class SensorConnect2 {
    
    private var mqtt: CocoaMQTT?
    var sensor: Topic!
    
    open var didReceiveMessage: (CocoaMQTT, CocoaMQTTMessage, UInt16) -> Void = { _, _, _ in }
    
    func connect(sensor: Topic) {
        self.sensor = sensor
        
//        let itemListService = ItemListService()
//        guard let configuration = itemListService.loadLocalConfiguration(uuid: sensor.serverUUID) else { return }
//        
//        guard let port = UInt16(configuration.port) else { return }
//        let clientID = sensor.uuid
//        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
//        mqtt?.username = configuration.username
//        mqtt?.password = configuration.password
//        mqtt?.keepAlive = 60
//        mqtt?.autoReconnectTimeInterval = 1
//        mqtt?.autoReconnect = true
//        mqtt?.connect()
//        
//        mqtt?.didConnectAck = { _,_  in
//            print("didConnectAck")
//            
//        }
//
//        mqtt?.didReceiveMessage = { [weak self] mqtt, message, id in
//            
//            print("#didReceiveMessage $$$$: \(message)")
//            guard let weakSelf = self else { return }
//            weakSelf.didReceiveMessage(mqtt, message, id)
//
//        }
//        
//        mqtt?.didConnectAck = { mqtt, ack in
//            
//            if ack == .accept {
//                
//                mqtt.subscribe(sensor.topic, qos: CocoaMQTTQOS.qos2)
//            }
//        }
    }
    
    func disconnect() {
        if mqtt == nil { } else {
            mqtt?.disconnect()
        }
    }
    
    func publish(message: String) {
        
        print("#publish message: \(message)")
        mqtt?.publish(sensor.topic , withString: message, qos: .qos0, retained: true, dup: false)
    }
}

