//
//  SelectionServerCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/10/19.
//

import UIKit

class SelectionServerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
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
        let server: String
        let isSelected: Bool
    }
}
