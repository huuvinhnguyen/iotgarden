//
//  SelectionServerCell.swift
//  IoTGarden
//
//  Created by chuyendo on 10/10/19.
//

import UIKit

class SelectionServerCell: UITableViewCell {
    
    var viewModel: SelectionViewModel? {
        didSet {
            
        }
    }
    
}

struct SelectionViewModel {
    let id: String
    let title: String
    var isSelected: Bool
}
