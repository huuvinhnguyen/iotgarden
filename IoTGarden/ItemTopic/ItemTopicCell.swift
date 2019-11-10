//
//  ItemTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit

class ItemTopicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    
    var viewModel: TopicViewModel? {
        didSet {
            nameLabel.text = viewModel?.name ?? ""
            topicLabel.text = viewModel?.topic ?? ""
        }
    }
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
}
