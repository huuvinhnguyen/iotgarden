//
//  ItemDetailHeaderCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit

class ItemDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: ItemDetailHeaderViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.name 
        }
    }
}

import RxDataSources

enum ItemDetailSectionModel {
    
    case headerSection(items: [ItemDetailSectionItem])
    case topicSection(items: [ItemDetailSectionItem])
}

enum ItemDetailSectionItem {
    
    case headerItem(viewModel: ItemDetailHeaderViewModel)
    case topicItem(viewModel: ItemDetailTopicViewModel)
}

extension ItemDetailSectionModel: SectionModelType {
    typealias Item = ItemDetailSectionItem
    
    var items: [ItemDetailSectionItem] {
        switch self {
        case .headerSection(items: let items):
            return items
        case .topicSection(items: let items):
            return items
        }
    }
    
    init(original: ItemDetailSectionModel, items: [Item]) {
        switch original {
        case let .headerSection(items):
            self = .headerSection(items: items)
        case let .topicSection(items):
            self = .topicSection(items: items)
        }
    }
}

struct ItemDetailHeaderViewModel {
    
    let name: String
}
