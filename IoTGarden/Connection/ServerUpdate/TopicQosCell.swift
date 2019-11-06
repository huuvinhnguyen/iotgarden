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
    
    var viewModel: TopicQosViewModel? {
        didSet {
            

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let buttons = [radio0Button, radio1Button, radio2Button].map { $0! }
        
        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map { button } }
            ).merge()
        buttons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
            
            
            return Disposables.create(disposable, subscription)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    
}

struct TopicQosViewModel {
    
}
