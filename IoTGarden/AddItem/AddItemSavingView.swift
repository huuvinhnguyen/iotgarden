//
//  AddItemSavingView.swift
//  IoTGarden
//
//  Created by Apple on 11/7/18.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class AddItemSavingView: UIView {
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var nameLineView: UIView?
    
    private let disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        nameTextField?.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
            
            self?.nameLineView?.backgroundColor = UIColor.yellow
        }).disposed(by: disposeBag)
        
        nameTextField?.rx.controlEvent([.editingDidEnd]).asObservable().subscribe({ [weak self] _ in
            
            self?.nameLineView?.backgroundColor = UIColor.lightGray
        }).disposed(by: disposeBag)
    }
}
