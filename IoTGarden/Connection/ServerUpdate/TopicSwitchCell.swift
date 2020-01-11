//
//  TopicSwitchCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/28/19.
//

import RxCocoa
import RxSwift

class TopicSwitchCell: UITableViewCell {
    
    @IBOutlet weak var onTextField: UITextField!
    @IBOutlet weak var offTextField: UITextField!
    
    var viewModelRelay = PublishRelay<ViewModel?>()
    private let disposeBag = DisposeBag()
    
    var viewModel: ViewModel? {
        didSet {
            onTextField.text = viewModel?.onText ?? ""
            offTextField.text = viewModel?.offText ?? ""
            viewModelRelay.accept(viewModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
    }
    
    private func configure() {
        onTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.onText = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        offTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.offText = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
    }
    
    struct ViewModel {
        var onText = ""
        var offText = ""
    }
}


