//
//  ServerCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import UIKit
import RxSwift
import RxCocoa

class ServerCell: UITableViewCell {
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    @IBOutlet private weak var userTextField: UITextField!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var serverTextField: UITextField!
    
    @IBOutlet private weak var portTextField: UITextField!
    
    @IBOutlet private weak var sslPortTextField: UITextField!
    
    var viewModelRelay = PublishRelay<ViewModel?>()
    
    var didTapSelectAction: (() -> Void)?
    
    private let disposeBag = DisposeBag()

    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    var viewModel: ViewModel? {
        didSet {
            
            nameTextField.text = viewModel?.name ?? ""
            serverTextField.text = viewModel?.serverUrl ?? ""
            userTextField.text = viewModel?.user ?? ""
            passwordTextField.text = viewModel?.password ?? ""
            portTextField.text = viewModel?.port ?? ""
            sslPortTextField.text = viewModel?.sslPort ?? ""
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
        var user = ""
        var password = ""
        var serverUrl = ""
        var port = ""
        var sslPort = ""
    }
    
    private func configure() {
        
        nameTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.name = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        serverTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.serverUrl = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        userTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.user = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        passwordTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.password = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
    }
}
