//
//  ItemNameHeaderCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/11/19.
//

import UIKit

class ItemNameHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var viewModel: ViewModel? {
        didSet {
            nameTextField.text = viewModel?.name
        }
    }
    
    struct ViewModel {
        var name = ""
    }
}
