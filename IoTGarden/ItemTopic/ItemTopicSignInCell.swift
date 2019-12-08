//
//  ItemTopicSignInCell.swift
//  IoTGarden
//
//  Created by chuyendo on 12/5/19.
//

import UIKit

class ItemTopicSignInCell: UITableViewCell {
    
    var didTapSignInAction: (() -> Void)?
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        didTapSignInAction?()
    }
}
