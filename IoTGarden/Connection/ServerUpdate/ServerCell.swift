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
    
    
    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        didTapSaveAction?()
    }
    
}

struct ServerViewModel {
    
}
