//
//  TopicRetainCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 2/16/20.
//

import UIKit
import RxCocoa
import RxSwift

class TopicRetainCell: UITableViewCell {
    
    @IBOutlet weak var radioNoButton: UIButton!
    @IBOutlet weak var radioYesButton: UIButton!
    
    private var disposeBag = DisposeBag()
    var viewModelRelay = PublishRelay<ViewModel?>()
    
    
    var viewModel: ViewModel? {
        didSet {
            if viewModel?.value == "0" {
                radioNoButton.isSelected = true
            } else if viewModel?.value == "1" {
                radioYesButton.isSelected = true
            }
        
            viewModelRelay.accept(viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
        let buttons = [radioNoButton, radioYesButton].map { $0! }
        
        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map { button } }
            ).merge()
        buttons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
            
            return Disposables.create(disposable, subscription)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configure() {
        radioNoButton.rx.tap.subscribe(onNext:{ [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.value = "0"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        radioYesButton.rx.tap.subscribe(onNext:{ [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.value = "1"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
    }
    
    struct ViewModel {
        var value = ""
    }
    
}
