//
//  AddItemView.swift
//  IoTGarden
//
//  Created by Apple on 11/7/18.
//
import UIKit
import RxSwift
import RxCocoa

class AddItemView: UIView {
    
    @IBOutlet weak var serverTextField: UITextField?
    @IBOutlet weak var serverLineView: UIView?
    
    @IBOutlet weak var userTextField: UITextField?
    @IBOutlet weak var userLineView: UIView?
    
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var passwordLineView: UIView?
    
    @IBOutlet weak var portTextField: UITextField?
    @IBOutlet weak var portLineView: UIView?

    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        serverTextField?.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
            
            self?.serverLineView?.backgroundColor = UIColor.yellow
        }).disposed(by: disposeBag)
        
        serverTextField?.rx.controlEvent([.editingDidEnd]).asObservable().subscribe({ [weak self] _ in
            
            self?.serverLineView?.backgroundColor = UIColor.lightGray
        }).disposed(by: disposeBag)
        
        
        userTextField?.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
            
            self?.userLineView?.backgroundColor = UIColor.yellow
        }).disposed(by: disposeBag)
        
        userTextField?.rx.controlEvent([.editingDidEnd]).asObservable().subscribe({ [weak self] _ in
            
            self?.userLineView?.backgroundColor = UIColor.lightGray
        }).disposed(by: disposeBag)
        
        passwordTextField?.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
            
            self?.passwordLineView?.backgroundColor = UIColor.yellow
        }).disposed(by: disposeBag)
        
        passwordTextField?.rx.controlEvent([.editingDidEnd]).asObservable().subscribe({ [weak self] _ in
            
            self?.passwordLineView?.backgroundColor = UIColor.lightGray
        }).disposed(by: disposeBag)
        
        portTextField?.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
            
            self?.portLineView?.backgroundColor = UIColor.yellow
        }).disposed(by: disposeBag)
        
        portTextField?.rx.controlEvent([.editingDidEnd]).asObservable().subscribe({ [weak self] _ in
            
            self?.portLineView?.backgroundColor = UIColor.lightGray
        }).disposed(by: disposeBag)
    }
}

class InputTextField: UITextView {
    
}

class ConnectButton: UIButton {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.layer.cornerRadius = 10; // this value vary as per your desire
        self.clipsToBounds = true;
    }
}
