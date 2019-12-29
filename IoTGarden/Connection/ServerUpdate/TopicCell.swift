//
//  TopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import RxSwift
import RxCocoa

class TopicCell: UITableViewCell {
    var didTapSelectAction: (() -> Void)?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var topicTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    var viewModelRelay = PublishRelay<ViewModel?>()
    
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
    
    private func configure() {
        
    }

}
