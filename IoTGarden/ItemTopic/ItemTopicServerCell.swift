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
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    @IBOutlet weak var sslPortLabel: UILabel!
    
    var viewModel: ViewModel? {
        didSet {
            nameLabel.text = viewModel?.name ?? ""
            serverLabel.text = viewModel?.server ?? ""
            userLabel.text = viewModel?.user ?? ""
            passLabel.text = viewModel?.password ?? ""
            portLabel.text = viewModel?.port ?? ""
            sslPortLabel.text = viewModel?.sslPort ?? ""
        }
    }
    
    var didTapEditAction: (() -> Void)?
    var didTapTrashAction: (() -> Void)?

    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    @IBAction func didTapTrashAction(_ sender: Any) {
        didTapTrashAction?()
    }
    
    struct ViewModel {
        var id = ""
        var name = ""
        var server = ""
        var user = ""
        var password = ""
        var port = ""
        var sslPort = ""
    }
}
