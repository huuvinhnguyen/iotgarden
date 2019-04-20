//
//  TemperatureCell.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class TemperatureCell: UICollectionViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?

    private weak var timer: Timer?

    
    fileprivate(set) var device: Device! {
        
        didSet {
            
            guard let temperatureDevice = device as? TemperatureDevice else { return }
            nameLabel?.text = temperatureDevice.name
            temperatureLabel?.text = temperatureDevice.valueString + "°C"
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel?.text = temperatureDevice.timeString.toDate()?.timeAgoDisplay()
            }
        }
    }
}

extension TemperatureCell: Display {
    
    func display(device: Device) {
        
        self.device = device
    }
}
