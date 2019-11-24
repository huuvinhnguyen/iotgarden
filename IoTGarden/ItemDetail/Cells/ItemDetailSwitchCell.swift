//
//  ItemDetailSwitchCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/5/19.
//

import UIKit

class ItemDetailSwitchCell: UITableViewCell {
    
    var didTapInfoAction: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
    
    var viewModel: TopicViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
        }
    }

}
