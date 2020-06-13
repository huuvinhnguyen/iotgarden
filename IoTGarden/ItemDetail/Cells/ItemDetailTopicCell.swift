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
import MaterialComponents

class ItemDetailTopicCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var valueTextField: MDCTextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    private weak var timer: Timer?
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
            timeLabel.text = ""
            valueTextField.rx.text.subscribe(onNext:{ [weak self] text in
                guard let self = self else { return }
               self.publishedMessage = text ?? ""
            }).disposed(by: self.disposeBag)
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel.text = weakSelf.viewModel?.time.toDate()?.timeAgoDisplay()
                
            }
            
            valueTextField.leadingUnderlineLabel.text = "sssss"
            valueTextField.isSecureTextEntry = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateConstraints()
    }
    
    struct ViewModel: IdentifiableType, Equatable {
        var id = ""
        var name = ""
        var value = ""
        var message = ""
        var time = ""
        
        typealias Identity = String
        var identity: String { return id }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.value == rhs.value && lhs.message == rhs.message && lhs.time == rhs.time
        }
        
    }
}
