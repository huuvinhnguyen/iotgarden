//
//  ItemImageCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//

import UIKit

class ItemImageCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton?
    
    var viewModel: ItemImageViewModel! {
        
        didSet {
            checkButton?.isSelected = viewModel.isSelected
        }
    }

    
}

struct ItemImageViewModel {
    let id: String
    var isSelected: Bool
    var imageUrl: String
}
