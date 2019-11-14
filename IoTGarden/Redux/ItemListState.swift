//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT


import ReSwift
struct ListState: ReSwift.StateType, Identifiable {
    
    var identifiableComponent = IdentifiableComponent()
    
    var sections: [ItemSectionModel] = []
    var sectionItems: [SectionItem] = []
    var topicItems: [ItemDetailSectionModel] = []
    var topicViewModel = TopicViewModel()
    var connectionViewModel = ConnectionViewModel(id:"", name: "hvm server", server: "https//icloud.com/", title: "", isSelected: true)
    var tasks: [String: SensorConnect2] = [:]
    var imageList: [ItemImageViewController.SectionModel] = []
    var itemImageViewModels: [ItemImageViewModel] = []
    var itemImageViewModel = ItemImageViewModel(id: "", isSelected: true, imageUrl: "")
    
}

extension ListState {
    enum Action: ReSwift.Action {
        case switchItem(cellUI: SwitchCellUI, message: String)
        case inputItem(cellUI: InputCellUI, message: String)
        case updateSwitchItem(viewModel: SwitchCellUI)
        case updateInputItem(cellUI: InputCellUI)
        case loadItems()
        case addItem(item: ItemListViewModel)
        case removeItem(id: String)
        case loadDetail(id: String)
//        case loadImages(list: [ItemImageViewController.SectionModel])
        case loadImages(list: [ItemImageViewModel])
        case selectImage(id: String)
        case fetchImages()
        case loadImage(viewModel: ItemImageViewModel)
    }
}
