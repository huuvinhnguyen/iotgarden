//
//  SensorConnect2.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import CocoaMQTT

class TopicConnector {
    
    private var mqtt: CocoaMQTT?
    var sensor: TopicData!
    var topic = Topic()
    
    open var didReceiveMessage: (CocoaMQTT, CocoaMQTTMessage, UInt16, Topic) -> Void = { _, _, _, _ in }
    
    func configure(topic: Topic, server: Server) {
//        let itemListService = ItemListService()
//        guard let configuration = itemListService.loadLocalConfiguration(uuid: sensor.serverUUID) else { return }
        
        guard let port = UInt16(server.port) else { return }
        self.topic = topic
        mqtt = CocoaMQTT(clientID: self.topic.id, host: server.url, port: port)
        mqtt?.username = server.user
        mqtt?.password = server.password
        mqtt?.keepAlive = 60
        mqtt?.autoReconnectTimeInterval = 1
        mqtt?.autoReconnect = true
        mqtt?.connect()
        
        mqtt?.didReceiveMessage = { [weak self] mqtt, message, id in
            
            print("#didReceiveMessage $$$$: \(message.string)")
            guard let weakSelf = self else { return }
            weakSelf.didReceiveMessage(mqtt, message, id, weakSelf.topic)
            
        }
        
        mqtt?.didConnectAck = { mqtt, ack in
            
            if ack == .accept {
                
                mqtt.subscribe(topic.topic, qos: CocoaMQTTQOS.qos2)
            }
        }

        
    }
    
    func connect() {
        mqtt?.connect()
    }
    
    
    func disconnect() {
        if mqtt == nil { } else {
            mqtt?.disconnect()
        }
    }
    
    func publish(message: String) {
        
        var qos: CocoaMQTTQOS = .qos0
        if topic.qos == "1" {
            qos = .qos1
        } else if topic.qos == "2" {
            qos = .qos2
        }
        
        let isRetained = topic.retain == "1"
        
        print("#publish message: \(message)")
        mqtt?.publish(topic.topic , withString: message, qos: qos, retained: isRetained, dup: false)
    }
}

