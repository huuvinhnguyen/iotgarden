//
//  ItemDetailTopicViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 7/26/19.
//

import UIKit
import CocoaMQTT

class ItemDetailTopicViewController:  UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var topicTextField: UITextField?
    
    var mqtt: CocoaMQTT?
    var configuration: Configuration?
    var kind: String?
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
//        guard let serverUUID = configuration?.uuid else { return }
//        
//        let itemListService = ItemListService()
//        guard let name = nameTextField?.text else { return }
//        guard let topic = topicTextField?.text else { return }
//        
//        guard let kind = self.kind else { return }
//        
//        let sensor = Sensor(uuid: UUID().uuidString, name: name, value: "0", serverUUID: serverUUID, kind: kind, topic: topic, time: "waiting")
//        itemListService.addSensor(sensor: sensor)
//        //        sensorListStore.dispatch(AddSensorAction())
//        itemListStore.dispatch(ListItemsAction())
//        navigationController?.popToRootViewController(animated: true)
    }
}

