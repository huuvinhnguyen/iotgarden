//
//  AddItemViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/1/18.
//

import UIKit
import CocoaMQTT
import CoreData


class AddItemViewController:  UIViewController {
    
    var mqtt: CocoaMQTT?
    private let itemListService = ItemListService()
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var serverTextField: UITextField?
    @IBOutlet weak var portTextField: UITextField?
    @IBOutlet weak var userTextField: UITextField?
    @IBOutlet weak var passTextField: UITextField?
    
    @IBOutlet weak var connectButton: UIButton?
    
    @IBAction func connect(sender: UIButton) {
        
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "m15.cloudmqtt.com", port: 11692)
        mqtt!.username = "quskfiwf"
        mqtt!.password = "HKfqtBl47aBR"
        mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "hello")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.connect()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier :"AddItemSavingViewController") as? AddItemSavingViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        guard let name = nameTextField?.text else { return }
        let item = Item(uuid: UUID().uuidString, name: name, isOn: true)
        itemListService.addLocalItem(item: item)
        itemListStore.dispatch(AddItemAction())
        navigationController?.popViewController(animated: true)
    }
}


extension AddItemViewController: CocoaMQTTDelegate {
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        /// Validate the server certificate
        ///
        /// Some custom validation...
        ///
        /// if validatePassed {
        ///     completionHandler(true)
        /// } else {
        ///     completionHandler(false)
        /// }
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        
        
        
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
