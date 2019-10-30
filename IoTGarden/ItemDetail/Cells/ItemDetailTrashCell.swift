//
//  ItemDetailTrashCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/8/19.
//

import UIKit

class ItemDetailTrashCell: UITableViewCell {
    var didTapTrashAction: (() -> Void)?
    
    @IBAction private func trashButtonTapped(_ sender: UIButton) {
        didTapTrashAction?()
    }
}
