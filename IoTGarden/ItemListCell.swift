//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?

    func configure(item: Item) {
        
        nameLabel?.text = item.name
        onOffSwitch?.isOn = item.isOn!
    }
}


