//
//  ItemTopicServerCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit

class ItemTopicServerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    @IBOutlet weak var sslPortLabel: UILabel!
    
    var viewModel: ConnectionViewModel? {
        didSet {
            nameLabel.text = viewModel?.name ?? ""
            serverLabel.text = viewModel?.server ?? ""
        }
    }
    
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    
}
