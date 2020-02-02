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
    
    var sections: [ItemSectionModel] = []
    var items: [ItemViewModel] = []
    var itemViewModel = ItemViewModel()
    var topicItems: [ItemDetailViewController.Section] = []
    var topicViewModel = Topic()
    var connectionViewModel = Server(id:"", name: "hvm server", url: "", user: "", password: "", port: "", sslPort: "555", canDelete: true)
    var tasks: [String: TopicConnector] = [:]
    var imageList: [ItemImageViewController.SectionModel] = []
    var itemImageViewModels: [ItemImageViewModel] = []
    var itemImageViewModel = ItemImageViewModel(id: "", isSelected: true, imageUrl: "")
    
}

extension ItemState {
    enum Action: ReSwift.Action {
        case switchItem(cellUI: SwitchCellUI, message: String)
        case inputItem(cellUI: InputCellUI, message: String)
        case updateSwitchItem(viewModel: SwitchCellUI)
        case loadItems()
        case addItem(item: ItemViewModel)
        case removeItem(id: String)
        case loadDetail(id: String)
        case loadImages(list: [ItemImageViewModel])
        case selectImage(id: String)
        case fetchImages()
        case loadImage(viewModel: ItemImageViewModel)
        case loadItem(id: String)
        case updateItemImage(imageUrl: String)
        case updateItem(item: ItemViewModel)
        
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
                        
                        dispatch(ItemState.Action.loadItems())
                    }
                }
                
                if case Action.removeItem(let id) = action {
                    let itemListService = ItemListService()
                    itemListService.removeItem(id: id) { _ in
                        dispatch(ItemState.Action.loadItems())
                        dispatch(TopicState.Action.removeTopics(itemId: id))
                    }
                }
                
                if case Action.updateItem(let viewModel) = action {
                    let itemListService = ItemListService()
                    itemListService.updateItem(item: ItemListService.ItemData(uuid: viewModel.uuid, name: viewModel.name, imageUrlString: viewModel.imageUrl, topics:[])) { _ in
                        dispatch(ItemState.Action.loadItems())
                    }
                  
                }
                
                next(action)
            }
        }
    }
    
}
