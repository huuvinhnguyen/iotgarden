//
//  ItemDetailViewController+.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 1/11/20.
//

import RxDataSources

extension ItemDetailViewController {
    
    enum Section: AnimatableSectionModelType {
        typealias Identity = String
        
        var identity: String {
            switch self {
            case .topicSection(_):
                return "abcdefgefe"
            default: return UUID().uuidString

            }
        }

        case headerSection(items: [SectionItem])
        case topicSection(items: [SectionItem])
        case footerSection(items: [SectionItem])
        
        typealias Item = SectionItem
       

        var items: [SectionItem] {
            switch self {
            case .headerSection(items: let items):
                return items
            case .topicSection(items: let items):
                return items
            case .footerSection(items: let items):
                return items
            }
        }
        
        
    
        init(original: Section, items: [Item]) {
            switch original {
            case let .headerSection(items):
                self = .headerSection(items: items)
            case let .topicSection(items):
                self = .topicSection(items: items)
            case let .footerSection(items):
                self = .footerSection(items: items)
            }
        
        }
        
        
//        static func == (lhs: Section, rhs: Section) -> Bool {
//            return lhs.items == rhs.items
//        }
    }
    
    enum SectionItem: IdentifiableType, Equatable {
        
        case headerItem(viewModel: ItemDetailHeaderCell.ViewModel)
        case topicItem
        case topicValueItem(viewModel: ItemDetailTopicCell.ViewModel)
        case topicSwitchItem(viewModel: ItemDetailSwitchCell.ViewModel)
        case topicGaugeItem(viewModel: ItemGaugeCell.ViewModel)
        case topicRelayItem(viewModel: ItemDetailSwitchCell.ViewModel)
        case topicTemperatureItem(viewModel: ItemDetailSwitchCell.ViewModel)
        case plusItem
        case trashItem
        case footerItem(viewModel: ItemDetailFooterViewModel)
        
        typealias Identity = String
        
        var identity: String {
            switch self {
            case .topicValueItem(let viewModel):
                return viewModel.id
            case .topicSwitchItem(let viewModel):
                return viewModel.id
            case .topicGaugeItem(let viewModel):
                return viewModel.id
            case .plusItem:
                return "plus"
            case .trashItem:
                return "trash"
            case .headerItem(_):
                return "header"
                
            
            default:
                return UUID().uuidString
            }
        }
        
        static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {
            if case SectionItem.topicSwitchItem(let vm1) = lhs {
                if case SectionItem.topicSwitchItem(viewModel: let vm2) = rhs {
                    return vm1 == vm2
                }
            }
            
            if case SectionItem.topicValueItem(let vm1) = lhs {
                if case SectionItem.topicValueItem(viewModel: let vm2) = rhs {
                    return vm1 == vm2
                }
            }
            
            return false
        }

    }
}
