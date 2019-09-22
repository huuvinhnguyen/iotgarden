//
//  ItemDetailSwitchCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/5/19.
//

import UIKit

class ItemDetailSwitchCell: UITableViewCell {
    
    var didTapInfoAction: (() -> Void)?
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
}
