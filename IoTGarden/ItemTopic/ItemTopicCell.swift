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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var retainLabel: UILabel!    
    
    var viewModel: ViewModel? {
        didSet {
            let model = viewModel ?? ViewModel()
            nameLabel.text = model.name
            valueLabel.text = model.value
            topicLabel.text = model.topic
            timeLabel.text = model.time
            qosLabel.text = model.qos
            if model.retain == "0" {
                retainLabel.text = "No"
            } else if model.retain == "1" {
                retainLabel.text = "Yes"
            } else { retainLabel.text = "Unknow" }
            typeLabel.text = model.type

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
        var retain = ""
        var type = ""
    }
}
