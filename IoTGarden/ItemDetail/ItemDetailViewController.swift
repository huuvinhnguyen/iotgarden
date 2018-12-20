//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/1/18.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    var sensor = Sensor()

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        
        print("Value changed")
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let itemListService = ItemListService()
        itemListService.removeSensor(sensor: sensor)
        itemListStore.dispatch(AddSensorAction())
        navigationController?.popViewController(animated: true)
    }
}
