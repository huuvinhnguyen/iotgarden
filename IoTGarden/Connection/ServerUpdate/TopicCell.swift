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
    
    private let disposeBag = DisposeBag()
    
    var viewModelRelay = PublishRelay<ViewModel?>()
    
    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    var viewModel: ViewModel? {
        didSet {
            nameTextField.text  = viewModel?.name ?? ""
            topicTextField.text = viewModel?.topic ?? ""
            typeTextField.text = viewModel?.type ?? ""
            viewModelRelay.accept(viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    struct ViewModel {
        var id = ""
        var name = ""
        var topic = ""
        var type = ""
    }
    
    private func configure() {
        nameTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.name = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        topicTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.topic = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        typeTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.type = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
    }

}
