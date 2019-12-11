//
//  ItemReducer.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReSwift

extension ItemState {
    
    public static func reducer(action: ReSwift.Action, state: ItemState?) -> ItemState {
        
        var state = state ?? ItemState()
        
        guard let action = action as? ItemState.Action else { return state }
        switch action {
            
//        case .updateSwitchItem(let switchCellUI):
//
//            let indexItem = state.sectionItems.firstIndex {
//                if case let .switchSectionItem(cellUI) = $0 {
//                    return cellUI.uuid == switchCellUI.uuid
//                }
//                return false
//            }
//
//            if let index = indexItem  {
//
//                state.sectionItems[index] = .switchSectionItem(cellUI: switchCellUI)
//                state.identifiableComponent.update()
//            }
            
//        case .updateInputItem(let inputCellUI):
//
//            let indexItem = state.sectionItems.firstIndex {
//                if case let .inputSectionItem(cellUI) = $0 {
//                    return cellUI.uuid == inputCellUI.uuid
//                }
//                return false
//            }
//
//            if let index = indexItem  {
//                state.sectionItems[index] = .inputSectionItem(cellUI: inputCellUI)
//                state.identifiableComponent.update()
//            }
            
//        case .loadItems():
//            
//            let itemListService = ItemListService()
//            
//            itemListService.loadItems { itemDatas in
//                let items: [SectionItem] = itemDatas.map { itemData in
//                    let viewModel = ItemViewModel(uuid: itemData.uuid, name: itemData.name, imageUrlString: itemData.imageUrlString)
//                    return .itemListSectionItem(viewModel: viewModel)
//                }
//                
//                state.sectionItems.removeAll()
//                let tailItem = SectionItem.tailSectionItem()
//                state.sectionItems.append(tailItem)
//                state.sectionItems += items
//                
//                
//                let sections: [ItemSectionModel] = [ .itemSection(title: "", items: state.sectionItems)]
//                state.sections = sections
//                state.identifiableComponent.update()
//                
//            }
        case .loadItems():
            let itemListService = ItemListService()
            
            itemListService.loadItems { itemDatas in
                let itemViewModels = itemDatas.map {
                    ItemViewModel(uuid: $0.uuid, name: $0.name, imageUrlString: $0.imageUrlString)
                }
            
                state.itemViewModels = itemViewModels
                state.identifiableComponent.update()
            }

        case .loadImages(let list):
            state.itemImageViewModels = list
            state.identifiableComponent.update()
        case .loadImage(let viewModel):
            state.itemImageViewModel = viewModel
            state.identifiableComponent.update()
            
            //        case .loadConnections():
            //
            //            let service = ItemListService()
            //            service.loadConfigures { configurations in
            //                state.servers = configurations.map { ServerViewModel(id: $0.uuid ,name: $0.name) }
            //            }
            //            state.identifiableComponent.update()
            
        default: ()
        }
        
        return state
    }
}

