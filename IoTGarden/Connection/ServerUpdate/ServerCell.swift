//
//  ServerCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import UIKit

class ServerCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var serverTextField: UITextField!
    
    @IBOutlet weak var portTextField: UITextField!
    
    var didTapSelectAction: (() -> Void)?
    
    var didTapSaveAction: (() -> Void)?
    
    var didTapTrashAction: (() -> Void)?

    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        didTapSaveAction?()
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        didTapTrashAction?()
    }
    
    var viewModel: ServerViewModel? {
        didSet {
            nameTextField.text = viewModel?.name ?? ""
            serverTextField.text = viewModel?.url ?? ""
            
        }
    }
}

struct ServerViewModel {
    let id: String
    let name: String
    let url: String
}
