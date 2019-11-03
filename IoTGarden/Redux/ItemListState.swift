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
    var tasks: [String: SensorConnect2] = [:]
    var imageList: [ItemImageViewController.SectionModel] = []
    
}

extension ListState {
    enum Action: ReSwift.Action {
        case switchItem(cellUI: SwitchCellUI, message: String)
        case inputItem(cellUI: InputCellUI, message: String)
        case updateSwitchItem(viewModel: SwitchCellUI)
        case updateInputItem(cellUI: InputCellUI)

        case loadItems()
        case addItem()
        case removeItem(id: String)
        case loadDetail(id: String)
        
        case loadImages(list: [ItemImageViewController.SectionModel])
        case selectImage(id: String)
        case fetchImages()
    }
}

let switchingMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            
            print("middleware action : \(action)")
            if case let ListState.Action.switchItem(cellUI: switchCellUI, message: message) = action {
                var switchCellUI = switchCellUI
                let state = getState()?.listState ?? ListState()
                let task = state.tasks[switchCellUI.uuid]
                
                task?.publish(message: message)
                task?.didReceiveMessage = {  mqtt, message, id in
                    print("#mqtt message: \(message)")
                    print("#clienti = \(mqtt.clientID)")

//                                        if message.string == "done" {
//
//                                            let formatter = DateFormatter()
//                                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                                            let dateString = formatter.string(from: Date())
//                                            switchCellViewModel.timeString = dateString
//                                        }
                    
                    
                    
                    
                    
                    switchCellUI.stateString = "Updated"
                    
                    switchCellUI.message = message.string ?? ""
                    if let sensor = task?.sensor {
                        let itemListService = ItemListService()
                        itemListService.updateSensor(sensor: sensor)
                    }
                    let action2 = ListState.Action.updateSwitchItem(viewModel: switchCellUI)
                    appStore.dispatch(action2)


                }
                
            } else {
                return next(action)
            }
        }
    }
}

let detailMiddleware: ReSwift.Middleware<ItemDetailState> = {  dispatch, getState in
    
    return { next in
        print("enter detail middleware")
        return { action in
            next(action)
        }
    }
}

let inputMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            
            print("middleware action : \(action)")
            if case let ListState.Action.inputItem(cellUI: inputCellUI, message: message) = action {
                var inputCellUI = inputCellUI
                let state = getState()?.listState ?? ListState()
                let task = state.tasks[inputCellUI.uuid]
                
                
                task?.publish(message: message)
                task?.didReceiveMessage = {  mqtt, message, id in
                    print("#mqtt message: \(message)")
                    print("#clienti = \(mqtt.clientID)")
                    
                                                            if message.string == "done" {
                    
                                                                let formatter = DateFormatter()
                                                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                                let dateString = formatter.string(from: Date())
                                                                inputCellUI.timeString = dateString
                                                            }
                    
                    
                    
                    
                    inputCellUI.message = message.string ?? ""

                    inputCellUI.stateString = "Updated"
                    
                    
                    if let sensor = task?.sensor {
                        let itemListService = ItemListService()
                        itemListService.updateSensor(sensor: sensor)
                    }
                    
                    let action2 = ListState.Action.updateInputItem(cellUI: inputCellUI)
                    appStore.dispatch(action2)
                    
                }
                
            } else {
                return next(action)
            }
        }
    }
}

let imageMiddleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
    
    return { next in
        
        return { action in
            if case let ListState.Action.selectImage(id) = action {
            
                var sections: [ItemImageViewController.SectionModel] = getState()?.listState.imageList ?? []
                let section: ItemImageViewController.SectionModel? = sections.first
                let sectionItems: [ItemImageViewController.SectionItem] = section.map {
                    if case let .itemSection(_, items) = $0 {
                        return items
                    } else {
                        return []
                    }
                } ?? []
                
                var viewModels: [ItemImageViewModel] = sectionItems.compactMap {
                    if case let .imageSectionItem(viewModel) = $0 {
                        return viewModel
                    }
                    return nil
                }
                
                var updatedViewModels: [ItemImageViewModel]  = viewModels.compactMap {
                    var viewModel = $0
                    viewModel.isSelected = false
                    return viewModel
                }
                
                if let index = updatedViewModels.firstIndex(where: {$0.id == id}) {
                    var viewModel = updatedViewModels[index]
                    viewModel.isSelected = true
                    updatedViewModels[index] = viewModel
                }

                
                let expectedItems:[ItemImageViewController.SectionItem] = updatedViewModels.compactMap {
                     ItemImageViewController.SectionItem.imageSectionItem(viewModel: $0)
                }
                
                let list: [ItemImageViewController.SectionModel] = [
                    .itemSection(title: "", items: expectedItems)
                ]
                
                
                dispatch(ListState.Action.loadImages(list: list))
                
            }
            
            if case ListState.Action.fetchImages() = action {
                
                let service = FirebaseService()
                service.getItems { items in
                    
                    let list: [ItemImageViewController.SectionModel] = [
                        .itemSection(title: "1", items: [
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "0", isSelected: true, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "1", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "2", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "3", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "4", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "5", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "6", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "7", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "8", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "9", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "10", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "11", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "12", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "13", isSelected: false, imageUrl: "")),
                            .imageSectionItem(viewModel: ItemImageViewModel(id: "14", isSelected: false, imageUrl: "")),
                            
                            ])
                    ]
                    
                    dispatch(ListState.Action.loadImages(list: list))
                }
            }
            next(action)
        }
    }
}



