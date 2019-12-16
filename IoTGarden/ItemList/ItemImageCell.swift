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
    
    var viewModel2: ViewModel! {
        
        didSet {
            checkButton?.isSelected = viewModel2.isSelected
            itemImageView.sd_setImage(with: URL(string: viewModel2.imageUrl), placeholderImage: R.image.icon_camera())
        }
    }
    
    struct ViewModel {
        var id = ""
        var isSelected = false
        var imageUrl = ""
    }
}

struct ItemImageViewModel {
    let id: String
    var isSelected: Bool
    var imageUrl: String
}
