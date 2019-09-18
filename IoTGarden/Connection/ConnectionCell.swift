//
//  ConnectionCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/18/19.
//

import UIKit

class ConnectionCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var markImageView: UIImageView!
    
    var viewModel: ConnectionViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            let isSelected = viewModel?.isSelected ?? false
            markImageView.isHidden = !isSelected
        }
    }
}
