//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/18.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    
    fileprivate(set) var cellViewModel: CellViewModel! {
        
        didSet {
            
            guard let viewModel = cellViewModel as? SwitchCellViewModel else { return }
            nameLabel?.text = viewModel.name
            onOffSwitch?.isOn = viewModel.isOn
            stateLabel?.text = viewModel.stateString
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel?.text = viewModel.timeString.toDate()?.timeAgoDisplay()
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?
    @IBOutlet weak var stateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    
    private weak var timer: Timer?
    
    @IBAction func switchButtonTapped(sender: UISwitch) {
        
        guard let switchDevice = cellViewModel as? SwitchCellViewModel else { return }
        switchDevice.stateString = "Requesting"
        
        stateLabel?.text = "Requesting"
        
        switchDevice.isOn =  sender.isOn
        let action = ListState.Action.switchItem(viewModel: switchDevice)
        appStore.dispatch(action)
    }
}

extension ItemListCell: Display {

    func display(cellViewModel: CellViewModel) {

        self.cellViewModel = cellViewModel
    }
}
