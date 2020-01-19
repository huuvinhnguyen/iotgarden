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
            let dataDictionary = convertToDictionary(text: viewModel?.message ?? "")
            onTextField.text = dataDictionary?["on"] ?? ""
            offTextField.text = dataDictionary?["off"] ?? ""
            viewModelRelay.accept(viewModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
    }
    
    private func configure() {
        onTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self, let vm = self.viewModel else { return }
            let dict = self.convertToDictionary(text: vm.message)
            let onValue = text ?? ""
            let offValue = dict?["off"] ?? ""
            self.viewModel?.message = "{\"on\":\"" + onValue + "\", \"off\":\"" + offValue + "\"}"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
        offTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self, let vm = self.viewModel else { return }
            let dict = self.convertToDictionary(text: vm.message)
            let onValue = dict?["on"] ?? ""
            let offValue = text ?? ""
            self.viewModel?.message = "{\"on\":\"" + onValue + "\", \"off\":\"" + offValue + "\"}"
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
    }
    
    struct ViewModel {

        var value = ""
        var message = ""
        
    }
    
    private func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}


