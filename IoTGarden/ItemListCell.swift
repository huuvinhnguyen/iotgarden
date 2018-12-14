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
            onOffSwitch?.isOn = viewModel.isOn!
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var onOffSwitch: UISwitch?
    private var itemConnect: ItemConnect?

    func configure(item: Item) {
        
        if let itemConnect = itemConnect {
            
            itemConnect.connect(item: item)
        } else {
            
            itemConnect = ItemConnect()
            itemConnect?.connect(item: item)
        }
        
        nameLabel?.text = item.name
        onOffSwitch?.isOn = item.isOn!
        
        itemConnect?.didReceiveMessage = { [weak self] mqtt, message, id in

            guard let weakSelf = self else { return }

            print("Message from topic \(message.topic) with payload \(message.string!)")
            if message.string == "1" {

                weakSelf.onOffSwitch?.isOn = true
            }

            if message.string == "0" {

                weakSelf.onOffSwitch?.isOn = false
            }
            weakSelf.setNeedsLayout()
            weakSelf.layoutIfNeeded()
        }
    }
    
    @IBAction func switchButtonTapped(sender: UISwitch) {
        
        let message =  sender.isOn ? "1":"0"
        itemConnect?.publish(message: message)
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

struct ItemListCellViewModel {
    
    var name: String?
    var isOn: Bool?
    
    init(item: Item) {
        
        name = item.name
        isOn = item.isOn
    }
}
