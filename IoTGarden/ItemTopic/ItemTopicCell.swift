//
//  ItemTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit

class ItemTopicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var qosLabel: UILabel!
    
    var viewModel: ViewModel? {
        didSet {
            
            nameLabel.text = viewModel?.name ?? ""
            valueLabel.text = viewModel?.value ?? ""
            topicLabel.text = viewModel?.topic ?? ""
            timeLabel.text = viewModel?.time ?? ""
            qosLabel.text = viewModel?.qos ?? ""

        }
    }
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    struct ViewModel {
        
        var id = ""
        var name = ""
        var topic = ""
        var value = ""
        var time = ""
        var qos = ""
    }
}
