//
//  SensorConnect.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import CocoaMQTT

class SensorConnect {
    
    private var mqtt: CocoaMQTT!
    
    open var didReceiveMessage: (CocoaMQTT, CocoaMQTTMessage, UInt16) -> Void = { _, _, _ in }
    
    func connect(sensor: Sensor) {
        
        let itemListService = ItemListService()
        guard let configuration = itemListService.loadLocalConfiguration(uuid: sensor.serverUUID) else { return }
        
        guard let port = UInt16(configuration.port) else { return }
        let clientID = "CocoaMQTT-" + configuration.uuid
        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
        mqtt.username = configuration.username
        mqtt.password = configuration.password
        mqtt.autoReconnectTimeInterval = 30
        mqtt.autoReconnect = true
        mqtt.connect()
        
        mqtt.didReceiveMessage = { [weak self] mqtt, message, id in
            
            guard let weakSelf = self else { return }
            print("#didReceiveMessage: \(message)")
            weakSelf.didReceiveMessage(mqtt, message, id)
            
        }
        
        mqtt.didConnectAck = { mqtt, ack in
            
            if ack == .accept {
                
                mqtt.subscribe("switch", qos: CocoaMQTTQOS.qos2)
            }
        }
    }
    
    func publish(message: String) {
        
        print("#publish message: \(message)")
        mqtt.publish("switch" , withString: message, qos: .qos0, retained: true, dup: false)
    }
}
