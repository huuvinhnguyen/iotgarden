//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    
    
    fileprivate(set) var device: Device! {
        
        didSet {
            
            guard let switchDevice = device as? SwitchDevice else { return }
            nameLabel?.text = switchDevice.name
            onOffSwitch?.isOn = switchDevice.isOn
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?

    
    @IBAction func switchButtonTapped(sender: UISwitch) {
        
        let message =  sender.isOn ? "1":"0"
        device.sensorConnect.publish(message: message)
    }
}

extension ItemListCell: Display {

    func display(device: Device) {

        self.device = device
    }
}
