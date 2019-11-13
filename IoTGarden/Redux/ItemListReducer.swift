//
//  ItemListReducer.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReSwift

extension ListState {
    
    public static func reducer(action: ReSwift.Action, state: ListState?) -> ListState {
        
        var state = state ?? ListState()
        
        guard let action = action as? ListState.Action else { return state }
        switch action {
            
        case .updateSwitchItem(let switchCellUI):
            
            let indexItem = state.sectionItems.firstIndex {
                if case let .switchSectionItem(cellUI) = $0 {
                    return cellUI.uuid == switchCellUI.uuid
                }
                return false
            }
            
            if let index = indexItem  {
                
                state.sectionItems[index] = .switchSectionItem(cellUI: switchCellUI)
                state.identifiableComponent.update()
            }
            
        case .updateInputItem(let inputCellUI):
            
            let indexItem = state.sectionItems.firstIndex {
                if case let .inputSectionItem(cellUI) = $0 {
                    return cellUI.uuid == inputCellUI.uuid
                }
                return false
            }
            
            if let index = indexItem  {
                state.sectionItems[index] = .inputSectionItem(cellUI: inputCellUI)
                state.identifiableComponent.update()
            }
            
        case .loadItems():
            
            let itemListService = ItemListService()
            
            itemListService.loadItems { itemDatas in
                let items: [SectionItem] = itemDatas.map { itemData in
                    let viewModel = ItemListViewModel(uuid: itemData.uuid, name: itemData.name, imageUrlString: itemData.imageUrlString)
                    return .itemListSectionItem(viewModel: viewModel)
                }
                
                state.sectionItems = items
                let tailItem = SectionItem.tailSectionItem()
                state.sectionItems.append(tailItem)
                
                let sections: [ItemSectionModel] = [ .itemSection(title: "", items: state.sectionItems)]
                state.sections = sections
                state.identifiableComponent.update()
                
            }
            
        case .loadImages(let list):
            state.itemImageViewModels = list
            state.identifiableComponent.update()
        case .loadImage(let viewModel):
            state.itemImageViewModel = viewModel
            
        default: ()
        }
        
        return state
    }
}
