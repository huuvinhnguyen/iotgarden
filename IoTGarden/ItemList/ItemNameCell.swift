//
//  ItemNameCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/11/19.
//

import UIKit

class ItemNameCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!
    
    var didTapSelectAction: (() -> Void)?
    
    var viewModel: ViewModel? {
        didSet {

            imageButton?.sd_setBackgroundImage(with: URL(string: viewModel?.imageUrl ?? ""), for: .normal) { [weak self] (image, error, type, url) in
                guard let self = self else { return }
                
                if (error != nil) {
                    self.imageButton.setBackgroundImage(R.image.icon_camera(), for: .normal)
                }
            }
        }
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
    struct ViewModel {
        var imageUrl = ""
    }
}

