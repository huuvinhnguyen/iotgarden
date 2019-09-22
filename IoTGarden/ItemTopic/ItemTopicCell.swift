//
//  ItemTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit

class ItemTopicCell: UITableViewCell {
    
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
}

struct ItemTopicViewModel {
    
}
