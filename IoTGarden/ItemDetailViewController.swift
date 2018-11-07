//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/1/18.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    var item = Item()
    let itemListService = ItemListService()

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        itemListService.removeLocalItem(uuid: item.uuid)
        itemListStore.dispatch(AddItemAction())
        navigationController?.popViewController(animated: true)
    }
}
