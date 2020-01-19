//
//  ItemDetailHeaderCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit

class ItemDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: ViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.name 
        }
    }
    
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    struct ViewModel {
        
        let name: String
    }
}
