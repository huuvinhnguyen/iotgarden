//
//  ItemDetailHeaderCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit

class ItemDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!

    
    var viewModel: ViewModel? {
        
        didSet {
            let url = URL(string: viewModel?.imageUrl ?? "")
            nameLabel.text = viewModel?.name
            itemImageView.sd_setImage(with: url)
            itemImageView.layer.cornerRadius  = itemImageView.frame.size.width / 2
        }
    }
    
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    struct ViewModel {
        
        let name: String
        let imageUrl: String
    }
}
