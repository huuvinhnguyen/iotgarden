//
//  ItemConnect.swift
//  IoTGarden
//
//  Created by Apple on 11/14/18.
//
import CocoaMQTT

class ItemConnect {
    
    private var mqtt: CocoaMQTT?
    
    open var didReceiveMessage: (CocoaMQTT, CocoaMQTTMessage, UInt16) -> Void = { _, _, _ in }

    func connect(item: Item) {
        
        let itemListService = ItemListService()
        guard let configuration = itemListService.loadLocalConfiguration(uuid: item.serverUUID) else { return }
        
        guard let port = UInt16(configuration.port) else { return }
        let clientID = "CocoaMQTT-" + configuration.uuid
        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
        mqtt!.username = configuration.username
        mqtt!.password = configuration.password
        mqtt!.delegate = self
        mqtt!.connect()
        
        mqtt!.didReceiveMessage = { mqtt, message, id in
            
            self.didReceiveMessage(mqtt, message, id)
            
        }
    }
    
    func connect(item: Item, finished: (_ fetchedItem: Item)->()) {
        let itemListService = ItemListService()
        guard let configuration = itemListService.loadLocalConfiguration(uuid: item.serverUUID) else { return }
        
        guard let port = UInt16(configuration.port) else { return }
        let clientID = "CocoaMQTT-" + configuration.uuid
        mqtt = CocoaMQTT(clientID: clientID, host: configuration.server, port: port)
        mqtt!.username = configuration.username
        mqtt!.password = configuration.password
        mqtt!.delegate = self
        mqtt!.connect()
        
        
        mqtt!.didConnectAck = { mqtt, ack in
            
            if ack == .accept {
                
                mqtt.subscribe("switch", qos: CocoaMQTTQOS.qos2)
            }
        }
    }
    
    func publish(message: String) {
        
        if let mqtt = mqtt {
            
            mqtt.publish("switch" , withString: message, qos: .qos2, retained: true, dup: false)
        }
    }
}

extension ItemConnect: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
 
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
        if ack == .accept {
            print("###Subscribed")
            mqtt.subscribe("switch", qos: CocoaMQTTQOS.qos2)
        }
        
    }
    

    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        
        print("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        
        print("didReceivedMessage: \(message.string ?? "") with id \(id)")
        didReceiveMessage(mqtt, message, id)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }
}
