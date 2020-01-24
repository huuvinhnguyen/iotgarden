//
//  ItemDetailTopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit
import Differentiator
import RxCocoa
import RxSwift

class ItemDetailTopicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    private let disposeBag = DisposeBag()

    var didTapInfoAction: (() -> Void)?
    var didTapPublishAction: ((String) -> Void)?
    
    private var publishedMessage: String = ""
    
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        didTapPublishAction?(publishedMessage)
    }
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }

    var viewModel: ViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.name ?? ""
            
            valueTextField.rx.text.subscribe(onNext:{ [weak self] text in
                guard let self = self else { return }
               self.publishedMessage = text ?? ""
            }).disposed(by: self.disposeBag)

        }
    }
    
    struct ViewModel: IdentifiableType, Equatable {
        var id = ""
        var name = ""
        var value = ""
        var message = ""
        
        typealias Identity = String
        var identity: String { return id }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.value == rhs.value && lhs.message == rhs.message
        }
        
    }
}
