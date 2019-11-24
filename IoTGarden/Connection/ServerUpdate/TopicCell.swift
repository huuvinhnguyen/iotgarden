//
//  TopicCell.swift
//  IoTGarden
//
//  Created by chuyendo on 9/23/19.
//

import UIKit

class TopicCell: UITableViewCell {
    var didTapSelectAction: (() -> Void)?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var topicTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    var viewModel: ViewModel? {
        didSet {
            nameTextField.text  = viewModel?.name ?? ""
            topicTextField.text = viewModel?.topic ?? ""
            typeTextField.text = viewModel?.type ?? ""
        }
    }
    
    struct ViewModel {
        let name: String?
        let topic: String?
        let type: String?
    }
}

struct TopicViewModel {
    var id = ""
    var name = ""
    var topic = ""
    var value = ""
    var time = ""
    var connectionId = ""
    var type = ""
}
