//
//  TopicQosCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/28/19.
//

import UIKit
import RxCocoa
import RxSwift

class TopicQosCell: UITableViewCell {
    
    @IBOutlet weak var radio0Button: UIButton!
    @IBOutlet weak var radio1Button: UIButton!
    @IBOutlet weak var radio2Button: UIButton!
    
    private var disposeBag = DisposeBag()
    var viewModelRelay = PublishRelay<ViewModel?>()

    
    var viewModel: ViewModel? {
        didSet {
            if viewModel?.value == "0" {
                radio0Button.isSelected = true
            } else if viewModel?.value == "1" {
                radio1Button.isSelected = true
            } else if viewModel?.value == "2" {
                radio2Button.isSelected = true
            }
            
            viewModelRelay.accept(viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
        let buttons = [radio0Button, radio1Button, radio2Button].map { $0! }
        
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
        radio0Button.rx.tap.subscribe(onNext:{ [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.value = "0"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        radio1Button.rx.tap.subscribe(onNext:{ [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.value = "1"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        radio2Button.rx.tap.subscribe(onNext:{ [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.value = "2"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
    }
    
 
    struct ViewModel {
        var value = ""
    }

}
