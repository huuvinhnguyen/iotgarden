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
            

        case .loadItems():
            let itemListService = ItemListService()
            
            itemListService.loadItems { itemDatas in
                let itemViewModels = itemDatas.map {
                    Item(uuid: $0.uuid, name: $0.name, imageUrl: $0.imageUrlString)
                }
            
                state.items = itemViewModels
                state.identifiableComponent.update()
            }

        case .loadImages(let list):
            state.images = list
            state.identifiableComponent.update()
        case .loadImage(let viewModel):
            state.image = viewModel
            state.identifiableComponent.update()
            
        case .loadItem(let id):
            let service = ItemListService()
            service.loadItem(id: id) { item in
                state.item = Item(uuid: item?.uuid ?? "", name: item?.name ?? "", imageUrl: item?.imageUrlString ?? "")
                state.identifiableComponent.update()
            }
            
        case .updateItemImage(let imageUrl):
            var item = state.item
            item.imageUrl = imageUrl
            state.item = item
            state.identifiableComponent.update()


        default: ()
        }
        
        return state
    }
}

