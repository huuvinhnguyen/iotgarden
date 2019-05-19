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
            stateLabel?.text = switchDevice.stateString
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel?.text = switchDevice.timeString.toDate()?.timeAgoDisplay()
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?
    @IBOutlet weak var stateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    
    private weak var timer: Timer?
    
    @IBAction func switchButtonTapped(sender: UISwitch) {
        
        guard let switchDevice = device as? SwitchDevice else { return }
        switchDevice.stateString = "Requesting"
        
        stateLabel?.text = "Requesting"
        
        let message =  sender.isOn ? "1":"0"
        device.sensorConnect.publish(message: message)
    }
}

extension ItemListCell: Display {

    func display(device: Device) {

        self.device = device
    }
}
