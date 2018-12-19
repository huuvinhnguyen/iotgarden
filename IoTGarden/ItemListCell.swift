//
//  ItemListCell.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit

class ItemListCell: UICollectionViewCell {
    
    fileprivate(set) var viewModel: ItemListCellViewModel! {
        
        didSet {
            
            nameLabel?.text = viewModel.name
            onOffSwitch?.isOn = viewModel.isOn
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?

    
    @IBAction func switchButtonTapped(sender: UISwitch) {
        
        let message =  sender.isOn ? "1":"0"
        viewModel.itemConnect.publish(message: message)
    }
}

extension ItemListCell: Display {
    
    func display(viewModel: ItemListCellViewModel) {
        
        self.viewModel = viewModel
    }
}

protocol Display {
    
    func display(viewModel: ItemListCellViewModel)
}

class ItemListCellViewModel {
    
    var name: String?
    var isOn: Bool = true
    var item: ToggleItem
    var itemConnect: ItemConnect
    
    init(item: ToggleItem) {
        
        self.item = item
        name = item.name
        isOn = item.isOn
        
        itemConnect = ItemConnect(item: item)
        
        configure(item: item)
    }
    
    func configure(item: ToggleItem) {

        itemConnect.connect(item: item)
        
        name = item.name
        isOn = item.isOn
        
        itemConnect.didReceiveMessage = { [weak self] mqtt, message, id in
            
            var newItem = item
            
            guard let weakSelf = self else { return }
            print("#Item name = \(item.name)")
            print("#Message from  topic \(message.topic) with payload \(message.string!)")
            if message.string == "1" {
                
                weakSelf.isOn = true
            }
            
            if message.string == "0" {
                
                weakSelf.isOn = false
            }

            newItem.isOn = weakSelf.isOn
            print("item.name = \(newItem.name)")
            itemStore.dispatch(UpdateItemAction(item: newItem))
            let itemListService = ItemListService()
            itemListService.updateItem(item: newItem)
        }
    }
}
