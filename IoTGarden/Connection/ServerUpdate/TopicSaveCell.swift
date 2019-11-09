//
//  TopicSaveCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/6/19.
//

import UIKit

class TopicSaveCell: UITableViewCell {
    
    var didTapSaveAction: (() -> Void)?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        didTapSaveAction?()
    }
    var viewModel: TopicSaveViewModel? {
        didSet {
            
        }
    }
    
}

struct TopicSaveViewModel {
    
}
