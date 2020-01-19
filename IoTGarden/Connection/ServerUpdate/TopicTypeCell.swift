//
//  TopicTypeCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/27/19.
//

import UIKit

class TopicTypeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var viewModel: ViewModel? {
        didSet {
            nameLabel.text = viewModel?.name ?? ""
            selectButton.isSelected = viewModel?.isSelected ?? false
        }
    }
    
    struct ViewModel {
        let id: String
        let name: String
        let isSelected: Bool
    }
}
