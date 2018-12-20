//
//  HumidityCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class HumidityCell: UICollectionViewCell {
    
    fileprivate(set) var device: Device!
}

extension HumidityCell: Display {
    
    func display(device: Device) {
        
        self.device = device
    }
}
