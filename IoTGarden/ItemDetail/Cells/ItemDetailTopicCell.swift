//
//  ItemDetailTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit

class ItemDetailTopicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    var viewModel: ItemDetailTopicViewModel? {
        
        didSet {
//            nameLabel.text = viewModel?.name ?? ""
//            valueLabel.text = viewModel?.value ?? ""
//            updatedLabel.text = viewModel?.updated ?? ""
        }
    }
}

struct ItemDetailTopicViewModel {
    
    let name: String
    let value: String
    let updated: String
    let type: String
}
