//
//  TopicCell.swift
//  IoTGarden
//
//  Created by chuyendo on 9/23/19.
//

import UIKit

class TopicCell: UITableViewCell {
    var didTapSelectAction: (() -> Void)?
    
    @IBAction private func selectButtonTapped(_ sender: UIButton) {
        didTapSelectAction?()
    }
}

struct TopicViewModel {
    var id = ""
    var name = ""
    var topic = ""
    var value = ""
    var time = ""
    var connectionId = ""
    var type = ""
}
