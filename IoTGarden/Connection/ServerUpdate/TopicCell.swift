//
//  TopicCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import RxSwift
import RxCocoa
import MaterialComponents.MaterialTextFields

class TopicCell: UITableViewCell {
    var didTapSelectAction: (() -> Void)?
    
    @IBOutlet weak var nameTextField: MDCTextField!
    
    @IBOutlet weak var topicTextField: OutlineTextField!
    
    @IBOutlet weak var typeTextField: MDCTextField!
    
    private let disposeBag = DisposeBag()
    
    var viewModelRelay = PublishRelay<ViewModel?>()
    
    lazy var topicTextFieldControllerFloating = MDCTextInputControllerUnderline()
    lazy var nameTextFieldControllerFloating = MDCTextInputControllerUnderline()
    
    lazy var inputControllerOutlined = MDCTextInputControllerOutlined()



    
    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    var viewModel: ViewModel? {
        didSet {
            
           
                nameTextField.text  = viewModel?.name ?? ""
                topicTextField.text = viewModel?.topic ?? ""
                viewModelRelay.accept(viewModel)
            
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

//        inputControllerOutlined.activeColor = .yellow
//        inputControllerOutlined.textInput = nameTextField
//        inputControllerOutlined.normalColor = .green
//        inputControllerOutlined.floatingPlaceholderActiveColor = .green
//        inputControllerOutlined.textInputFont = .systemFont(ofSize: 25)
//        inputControllerOutlined.inlinePlaceholderFont = .systemFont(ofSize: 25)

        
//        
//        topicTextFieldControllerFloating.normalColor = .red
////        topicTextFieldControllerFloating.floatingPlaceholderNormalColor = .red
//        topicTextFieldControllerFloating.expandsOnOverflow = true
////        topicTextFieldControllerFloating.floatingPlaceholderActiveColor = .lightGray
////        topicTextFieldControllerFloating.activeColor = .yellow
//        topicTextFieldControllerFloating.textInput = topicTextField
//        
//        nameTextFieldControllerFloating.normalColor = .red
////        nameTextFieldControllerFloating.floatingPlaceholderNormalColor = .red
//        nameTextFieldControllerFloating.expandsOnOverflow = true
//        nameTextFieldControllerFloating.floatingPlaceholderActiveColor = .lightGray
//        nameTextFieldControllerFloating.activeColor = .yellow
//        nameTextFieldControllerFloating.textInput = nameTextField
        
        
    

        
        
       

    }
    
    struct ViewModel {
        var id = ""
        var name = ""
        var topic = ""
        var type = ""
    }
    
    func configure(viewModel: ViewModel?) {

        if self.viewModel == nil {
            self.viewModel = viewModel
        }
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
        
        typeTextField.text = viewModel?.type ?? ""
 
        typeTextField.rx.text.subscribe(onNext:{ [weak self] text in
            guard let self = self else { return }
            self.viewModel?.type = text ?? ""
            self.viewModelRelay.accept(self.viewModel)
        }).disposed(by: self.disposeBag)
        
    }
}


class OutlineTextField: MDCTextField {
    var inputControllerOutlined = MDCTextInputControllerFilled()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    
    
    func createBorder(){
        
//        inputControllerOutlined.activeColor = .yellow
        inputControllerOutlined.textInput = self
        inputControllerOutlined.normalColor = .green
        inputControllerOutlined.floatingPlaceholderActiveColor = .green
        inputControllerOutlined.textInputFont = .systemFont(ofSize: 16)
        inputControllerOutlined.inlinePlaceholderFont = .systemFont(ofSize: 16)
        inputControllerOutlined.borderFillColor = .purple
        inputControllerOutlined.leadingUnderlineLabelTextColor = .red
        inputControllerOutlined.characterCountMax = 200
        inputControllerOutlined.helperText = "AAAAAA"
        leadingUnderlineLabel
        backgroundColor = .cyan
        
    
    }
}


