//
//  ItemInputValueCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 6/8/19.
//

import UIKit

class ItemInputValueCell: UICollectionViewCell {
    
    @IBOutlet weak var stateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var inputTextField: UITextField?
    
    fileprivate(set) var cellViewModel: CellViewModel! {
        didSet {
            
            guard let inputDevice = cellViewModel as? InputDevice else { return }
            nameLabel?.text = inputDevice.name
            stateLabel?.text = inputDevice.stateString
            timeLabel?.text = inputDevice.timeString

        }
    }
    
    @IBAction func updateButtonTapped(sender: UISwitch) {
        
        guard let inputDevice = cellViewModel as? InputDevice else { return }
        inputDevice.stateString = "Requesting"
        
        stateLabel?.text = "Requesting"
        
        let message =  inputTextField?.text ?? ""
        cellViewModel.sensorConnect.publish(message: message)
    }
}

extension ItemInputValueCell: Display {
    
    func display(cellViewModel: CellViewModel) {
        
        self.cellViewModel = cellViewModel
    }
}
