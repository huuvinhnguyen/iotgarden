//
//  ItemNameCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/11/19.
//

import UIKit

class ItemNameCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    
    var viewModel: ViewModel? {
        didSet {
            imageButton.sd_setBackgroundImage(with: URL(string: viewModel?.imageUrl ?? ""), for: .normal, completed: nil)
        }
    }
    struct ViewModel {
        var imageUrl = ""
    }
}

