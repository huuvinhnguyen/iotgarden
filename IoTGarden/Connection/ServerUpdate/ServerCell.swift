//
//  ServerCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/23/19.
//

import UIKit

class ServerCell: UITableViewCell {
    
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
}

struct ServerViewModel {
    let id: String
    let name: String
    let url: String
}
