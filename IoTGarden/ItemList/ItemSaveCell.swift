//
//  ItemSaveCell.swift
//  IoTGarden
//
//  Created by chuyendo on 12/12/19.
//

import UIKit

class ItemSaveCell: UITableViewCell {
    
    var didTapSaveAction: (() -> Void)?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        didTapSaveAction?()
    }
    var viewModel: ViewModel? {
        didSet {
            
        }
    }
    
    struct ViewModel {
        
    }
}
