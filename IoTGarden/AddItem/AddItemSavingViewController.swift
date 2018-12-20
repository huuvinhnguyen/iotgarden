//
//  AddItemSavingViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/7/18.
//

import UIKit
import CocoaMQTT

class AddItemSavingViewController:  UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField?
    var mqtt: CocoaMQTT?
    var configuration: Configuration?
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        
        guard let serverUUID = configuration?.uuid else { return }
        
        let itemListService = ItemListService()
        guard let name = nameTextField?.text else { return }
//        let item = ToggleItem(uuid: UUID().uuidString, name: name, isOn: true, serverUUID: serverUUID, kind: .toggle)
//        itemListService.addLocalItem(item: item)
        let sensor = Sensor(uuid: UUID().uuidString, name: name, value: "0", serverUUID: serverUUID, kind: .toggle)
        itemListService.addSensor(sensor: sensor)
        sensorListStore.dispatch(AddSensorAction())
        navigationController?.popToRootViewController(animated: true)
    }
}
