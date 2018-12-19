//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/1/18.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    var item = ToggleItem()

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        
        print("Value changed")
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let itemListService = ItemListService()
        itemListService.removeLocalItem(uuid: item.uuid)
        itemListStore.dispatch(AddItemAction())
        navigationController?.popViewController(animated: true)
    }
}
