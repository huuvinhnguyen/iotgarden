//
//  AddItemTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/18/19.
//


import UIKit

class AddItemTopicCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var markImageView: UIImageView!
    
    var viewModel: AddItemTopicViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            let isSelected = viewModel?.isSelected ?? false
            markImageView.isHidden = !isSelected
        }
    }
}
