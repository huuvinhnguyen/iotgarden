//
//  ItemDetailSwitchCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/5/19.
//

import UIKit

class ItemDetailSwitchCell: UITableViewCell {
    
    var didTapInfoAction: (() -> Void)?
    var didTapSwitchAction: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBAction private func switchButtonTapped(_ sender: UIButton) {
        didTapSwitchAction?()
    }
    
    
    var viewModel: Topic? {
        didSet {
            nameLabel.text = viewModel?.name
            valueLabel.text = viewModel?.value
        }
    }

}
