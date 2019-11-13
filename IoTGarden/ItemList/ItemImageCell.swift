//
//  ItemImageCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//

import UIKit
import SDWebImage

class ItemImageCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton?
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    var viewModel: ItemImageViewModel! {
        
        didSet {
            checkButton?.isSelected = viewModel.isSelected
            itemImageView.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: R.image.icon_camera())
        }
    }

    
}

struct ItemImageViewModel {
    let id: String
    var isSelected: Bool
    var imageUrl: String
}
