//
//  HumidityCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class HumidityCell: UICollectionViewCell {
    
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?

    
    fileprivate(set) var cellViewModel: CellViewModel! {
        didSet {
            
            guard let humidityDevice = cellViewModel as? HumidityDevice else { return }
            nameLabel?.text = humidityDevice.name
            humidityLabel?.text = humidityDevice.valueString + "%"
            timeLabel?.text = humidityDevice.timeString
        }
    }
}

extension HumidityCell: Display {
    
    func display(cellViewModel: CellViewModel) {
        
        self.cellViewModel = cellViewModel
    }
}
