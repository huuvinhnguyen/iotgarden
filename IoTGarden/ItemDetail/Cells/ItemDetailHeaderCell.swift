//
//  ItemDetailHeaderCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 8/24/19.
//

import UIKit

class ItemDetailHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: ViewModel? {
        
        didSet {
            nameLabel.text = viewModel?.name 
        }
    }
    
    var didTapEditAction: (() -> Void)?
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        didTapEditAction?()
    }
    
    struct ViewModel {
        
        let name: String
    }
}

import RxDataSources

enum ItemDetailSectionModel {
    
    case headerSection(items: [ItemDetailSectionItem])
    case topicSection(items: [ItemDetailSectionItem])
    case footerSection(items: [ItemDetailSectionItem])
}

enum ItemDetailSectionItem {
    
    case headerItem(viewModel: ItemDetailHeaderCell.ViewModel)
    case topicItem(viewModel: Topic?)
    case footerItem(viewModel: ItemDetailFooterViewModel)
}

extension ItemDetailSectionModel: SectionModelType {
    typealias Item = ItemDetailSectionItem
    
    var items: [ItemDetailSectionItem] {
        switch self {
        case .headerSection(items: let items):
            return items
        case .topicSection(items: let items):
            return items
        case .footerSection(items: let items):
            return items
        }
    }
    
    init(original: ItemDetailSectionModel, items: [Item]) {
        switch original {
        case let .headerSection(items):
            self = .headerSection(items: items)
        case let .topicSection(items):
            self = .topicSection(items: items)
        case let .footerSection(items):
            self = .footerSection(items: items)
        }
    }
}

struct ItemDetailHeaderViewModel {
    
    enum SectionItem {
        
        case headerItem(viewModel: ItemDetailHeaderCell.ViewModel)
        case topicItem(viewModel: Topic?)
        case footerItem(viewModel: ItemDetailFooterViewModel)
    }

}
