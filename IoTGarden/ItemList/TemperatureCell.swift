//
//  TemperatureCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class TemperatureCell: UICollectionViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel?
    
    fileprivate(set) var device: Device! {
        
        didSet {
            
            guard let temperatureDevice = device as? TemperatureDevice else { return }
            temperatureLabel?.text = temperatureDevice.valueString
            
        }
    }
}

extension TemperatureCell: Display {
    
    func display(device: Device) {
        
        self.device = device
    }
}
