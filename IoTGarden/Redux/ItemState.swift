//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT


import ReSwift
struct ItemState: ReSwift.StateType, Identifiable {
    
    var identifiableComponent = IdentifiableComponent()
    
    var items: [Item] = []
    var item = Item()
    var images: [Image] = []
    var image = Image(id: "", isSelected: true, imageUrl: "")
    
}

extension ItemState {
    enum Action: ReSwift.Action {
        case switchItem(cellUI: SwitchCellUI, message: String)
        case inputItem(cellUI: InputCellUI, message: String)
        case updateSwitchItem(viewModel: SwitchCellUI)
        case loadItems
        case addItem(item: Item)
        case removeItem(id: String)
        case loadDetail(id: String)
        case loadImages(list: [Image])
        case selectImage(id: String)
        case fetchImages
        case loadImage(viewModel: Image)
        case loadItem(id: String)
        case updateItemImage(imageUrl: String)
        case updateItem(item: Item)
        
    }
}

extension ItemState {
    
    static let middleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
        
        return { next in
            print("enter detail middleware")
            return { action in
                if case Action.addItem(let viewModel) = action {
                    let service = ItemListService()
                    service.addItem(item: ItemListService.ItemData(uuid: viewModel.uuid, name: viewModel.name, imageUrlString: viewModel.imageUrl, topics:[])) { item in
                        
                        dispatch(ItemState.Action.loadItems)
                    }
                }
                
                if case Action.removeItem(let id) = action {
                    let itemListService = ItemListService()
                    itemListService.removeItem(id: id) { _ in
                        dispatch(ItemState.Action.loadItems)
                        dispatch(TopicState.Action.removeTopics(itemId: id))
                    }
                }
                
                if case Action.updateItem(let viewModel) = action {
                    let itemListService = ItemListService()
                    itemListService.updateItem(item: ItemListService.ItemData(uuid: viewModel.uuid, name: viewModel.name, imageUrlString: viewModel.imageUrl, topics:[])) { _ in
                        dispatch(ItemState.Action.loadItems)
                    }
                  
                }
                
                if case Action.fetchImages = action {
                    let service = FirebaseService()
                    service.getItems(finished: { items in
                        let list = items.map {
                            Image(id: $0.id ?? "", isSelected: false, imageUrl: $0.imageUrl ?? "")
                        }
                        dispatch(ItemState.Action.loadImages(list: list))
                    })
                }
                
                if case Action.selectImage(let id) = action {
                    var images: [Image] = getState()?.itemState.images ?? []
                    var newImages: [Image] = images.compactMap {
                        var newImage = $0
                        newImage.isSelected = $0.id == id
                       
                        return newImage
                    }
                    
                    dispatch(ItemState.Action.loadImages(list: newImages))
                
                }
                
                next(action)
            }
        }

    }
}
