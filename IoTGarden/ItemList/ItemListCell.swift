//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit
import ReSwift

import ReSwift

struct LoadItemListCellAction: Action {
    
    var state: ItemListCellState

}
struct ItemListCellState: StateType {
    var cellViewModel: CellViewModel?
//    var sensorConnect: SensorConnect?
}

let itemListCellReducer: Reducer<ItemListCellState> = { action, state in
    
    var state = state ?? ItemListCellState()
    
    if let action = action as? LoadItemListCellAction {
        
        state = action.state
        
    }
    
    return state
}

let itemListCellStore = Store<ItemListCellState>(
    reducer: itemListCellReducer,
    state: nil
)


class ItemListCell: UICollectionViewCell, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ItemListCellState
    
    fileprivate(set) var cellViewModel: CellViewModel! {
        
        didSet {
            
            itemListCellStore.subscribe(self)
            itemListCellStore.dispatch(LoadItemListCellAction(state: ItemListCellState(cellViewModel: cellViewModel)))

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
        
        let message =  sender.isOn ? "1":"0"
        cellViewModel.sensorConnect.publish(message: message)
    }
    
    func newState(state: ItemListCellState) {
        
        guard let viewModel = cellViewModel as? SwitchCellViewModel else { return }
//        guard let viewModel = state.cellViewModel as? SwitchCellViewModel else { return }
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

extension ItemListCell: Display {

    func display(cellViewModel: CellViewModel) {

        self.cellViewModel = cellViewModel
    }
}
