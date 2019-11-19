//
//  ItemDetailServerViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 7/26/19.
//

import UIKit
import CocoaMQTT

class ItemDetailServerViewController:  UIViewController {
    
    
    @IBOutlet weak var serverTextField: UITextField?
    @IBOutlet weak var portTextField: UITextField?
    @IBOutlet weak var userTextField: UITextField?
    @IBOutlet weak var passTextField: UITextField?
    
    @IBOutlet weak var connectButton: UIButton?
    
    var serverUUID: String?
    
    fileprivate var configuration: ItemListService.Configuration?
    
    @IBAction func connectButtonTapped(sender: UIButton) {
        
        let uuid = UUID().uuidString
        let server = serverTextField?.text ?? ""
        let port = portTextField?.text ?? ""
        let username = userTextField?.text ?? ""
        let password = passTextField?.text ?? ""
        
        //                    let uuid = UUID().uuidString
        //                    let server = "m15.cloudmqtt.com"
        //                    let username = "rdgbdjfq"
        //                    let password = "jtWqc7RiUsz-"
        //                    let port = "14985"
        
//        configuration = Configuration(uuid: uuid, server: server, username: username, password: password, port: port)
        
        guard let configuration = configuration else { return }
        guard let portInt = UInt16(configuration.port) else { return }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let itemListService = ItemListService()
        guard let configuration = itemListService.loadLocalConfiguration(uuid: serverUUID ?? "") else { return }
        serverTextField?.text = configuration.server
        portTextField?.text = configuration.port
        userTextField?.text = configuration.username
        passTextField?.text = configuration.password
    }
}

extension ItemDetailServerViewController: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        
        
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        if ack == .accept {
            
            
            mqtt.subscribe("switch", qos: CocoaMQTTQOS.qos1)
            
            
            
            let itemListService = ItemListService()
            guard let configuration = self.configuration else { return }
//            itemListService.addLocalConfiguration(configuration: configuration)
            
            
            if let vc = storyboard?.instantiateViewController(withIdentifier :"SelectionViewController") as? SelectionViewController {
                
//                vc.configuration = configuration
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string ?? "") with id \(id)")
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

