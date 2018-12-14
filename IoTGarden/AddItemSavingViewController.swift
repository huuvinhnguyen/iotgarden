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
        let item = Item(uuid: UUID().uuidString, name: name, isOn: true, serverUUID: serverUUID)
        itemListService.addLocalItem(item: item)
        itemListStore.dispatch(AddItemAction())
        navigationController?.popToRootViewController(animated: true)
    }
}
