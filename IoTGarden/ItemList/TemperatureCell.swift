//
//  TemperatureCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class TemperatureCell: UICollectionViewCell {
    
    fileprivate(set) var device: Device!
}

extension TemperatureCell: Display {
    
    func display(device: Device) {
        
        self.device = device
    }
}
