//
//  ItemDetailPlusCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/8/19.
//

import UIKit

class ItemDetailPlusCell: UITableViewCell {
    
    var didTapPlusAction: (() -> Void)?
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        didTapPlusAction?()
    }
}
