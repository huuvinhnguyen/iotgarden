//
//  SelectionCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class SelectionCell: UICollectionViewCell {
    
     @IBOutlet weak var titleLabel: UILabel?
    var viewModel: ViewModel? {
        didSet {
            
        }
    }
    
    struct ViewModel {
        let server: String
        let isSelected: Bool
    }
}
