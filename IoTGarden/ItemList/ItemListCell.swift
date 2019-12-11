//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/18.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    var switchCellUI: SwitchCellUI?
    var viewModel: ItemViewModel? {
        didSet {
            itemImageView.sd_setImage(with: URL(string: viewModel?.imageUrlString ?? ""), placeholderImage: R.image.icon_camera())
            
        }
    }
    
    var viewModel2: ViewModel? {
        didSet {
            nameLabel?.text = viewModel2?.name
            itemImageView.sd_setImage(with: URL(string: viewModel2?.imageUrl ?? ""), placeholderImage: R.image.icon_camera())
        }
    }
    
    fileprivate(set) var cellViewModel: CellViewModel! {
        
        didSet {
            
            
            guard let viewModel = cellViewModel as? SwitchCellViewModel else { return }
            nameLabel?.text = viewModel.name
            onOffSwitch?.isOn = viewModel.isOn
            stateLabel?.text = viewModel.stateString
            
            print("#state string: \(viewModel.stateString)")
            
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
        
        
        guard let cellUI = switchCellUI else { return }
        stateLabel?.text = "Requesting"
        let action = ItemState.Action.switchItem(cellUI: cellUI, message: sender.isOn ? "1" : "0")
        appStore.dispatch(action)

        
    }
    
    func configure(cellUI: SwitchCellUI) {
        switchCellUI = cellUI
        
        nameLabel?.text = cellUI.name
        onOffSwitch?.isOn = cellUI.isOn
        stateLabel?.text = cellUI.stateString
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let weakSelf = self else { return }
            weakSelf.timeLabel?.text = cellUI.timeString.toDate()?.timeAgoDisplay()
        }
        
    }
    
    struct ViewModel {
        var uuid = ""
        var name = ""
        var imageUrl = ""
    }
}

extension ItemListCell: Display {

    func display(cellViewModel: CellViewModel) {

        self.cellViewModel = cellViewModel
    }
}

struct SwitchCellUI: CellUI {

    var uuid: String
    var isOn: Bool {
            return message == "1"
    }
    var name: String
    var stateString: String = "Requesting"
    var timeString  = ""
    var message: String

}

struct ItemViewModel {
    var uuid: String = ""
    var name: String = ""
    var imageUrlString = ""
    
}


