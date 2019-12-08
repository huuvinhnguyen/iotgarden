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
    
    var viewModel3: ViewModel? {
        didSet {
            nameLabel.text = viewModel3?.name ?? ""
            serverLabel.text = viewModel3?.server ?? ""
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
        var title = ""
    }
}
