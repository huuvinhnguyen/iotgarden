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
    
    var inputCellUI: InputCellUI?

    
    fileprivate(set) var cellViewModel: CellViewModel! {
        didSet {
            
            guard let inputDevice = cellViewModel as? InputDevice else { return }
            nameLabel?.text = inputDevice.name
            stateLabel?.text = inputDevice.stateString
            timeLabel?.text = inputDevice.timeString

        }
    }
    
    @IBAction func updateButtonTapped(sender: UISwitch) {
        
        guard let cellUI = inputCellUI else { return }
        stateLabel?.text = "Requesting"
        let message =  inputTextField?.text ?? ""

        let action = ListState.Action.inputItem(cellUI: cellUI, message: message)
        appStore.dispatch(action)
    }
    
    func configure(cellUI: InputCellUI) {
        
        inputCellUI = cellUI

        nameLabel?.text = cellUI.name
        stateLabel?.text = cellUI.stateString
        timeLabel?.text = cellUI.timeString
    }
}

extension ItemInputValueCell: Display {
    
    func display(cellViewModel: CellViewModel) {
        
        self.cellViewModel = cellViewModel
    }
}


struct InputCellUI: CellUI {
    var uuid: String
    var isOn: Bool = true
    var name: String
    var stateString: String = "Requesting"
    var timeString  = ""
    var message: String
}


