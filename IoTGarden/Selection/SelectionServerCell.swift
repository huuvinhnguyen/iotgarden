//
//  SelectionServerCell.swift
//  IoTGarden
//
//  Created by chuyendo on 10/10/19.
//

import UIKit

class SelectionServerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var viewModel: ServerViewModel? {
        didSet {
            nameLabel.text = viewModel?.name ?? ""
        }
    }
    
}

struct SelectionViewModel {
    let id: String
    let title: String
    var isSelected: Bool
}
