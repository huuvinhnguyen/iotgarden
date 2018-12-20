//
//  ItemDetailTempViewController.swift
//  IoTGarden
//
//  Created by Apple on 12/14/18.
//

import UIKit

class ItemDetailTempViewController: UIViewController {
    
    var item = ItemTemp()
    
   
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tempLabel.text = "\(item.temp)"
    }
}
