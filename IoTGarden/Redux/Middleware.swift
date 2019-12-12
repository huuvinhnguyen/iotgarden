//
//  Middleware.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/27/19.
//

import ReSwift

let itemListMiddleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
    
    return { next in
        print("enter detail middleware")
        return { action in
            if case ItemState.Action.addItem(let viewModel) = action {
                    let service = ItemListService()
                service.addItem(item: ItemListService.ItemData(uuid: viewModel.uuid, name: viewModel.name, imageUrlString: viewModel.imageUrlString, topics:[])) { item in
                    
                    dispatch(ItemState.Action.loadItems())
                }
            }
            
            if case ItemState.Action.removeItem(let id ) = action {
                let itemListService = ItemListService()
                itemListService.removeItem(id: id) { _ in
                    dispatch(ItemState.Action.loadItems())
                }
            }

            next(action)
        }
    }
}


let switchingMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            
            print("middleware action : \(action)")
            if case let ItemState.Action.switchItem(cellUI: switchCellUI, message: message) = action {
                var switchCellUI = switchCellUI
                let state = getState()?.itemState ?? ItemState()
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
                        itemListService.updateTopic(topic: sensor)
                    }
                    let action2 = ItemState.Action.updateSwitchItem(viewModel: switchCellUI)
                    appStore.dispatch(action2)
                    
                    
                }
                
            } else {
                return next(action)
            }
        }
    }
}

let inputMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            
            
            print("middleware action : \(action)")
            if case let ItemState.Action.inputItem(cellUI: inputCellUI, message: message) = action {
                var inputCellUI = inputCellUI
                let state = getState()?.itemState ?? ItemState()
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
                        itemListService.updateTopic(topic: sensor)
                    }
                    
                    let action2 = ItemState.Action.updateInputItem(cellUI: inputCellUI)
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
            if case let ItemState.Action.selectImage(id) = action {
                
                 var viewModels: [ItemImageViewModel] = getState()?.itemState.itemImageViewModels.compactMap {
                    var viewModel = $0
                    viewModel.isSelected = false
                    return viewModel
                    } ?? []
                
                if let index = viewModels.firstIndex(where: {$0.id == id}) {
                    var viewModel = viewModels[index]
                    viewModel.isSelected = true
                    viewModels[index] = viewModel
                    dispatch(ItemState.Action.loadImage(viewModel: viewModel))

                }
                
                dispatch(ItemState.Action.loadImages(list: viewModels))
                
            }
            
            if case ItemState.Action.fetchImages() = action {
                
                let service = FirebaseService()
                service.getItems { items in
                    
                    let list = items.map { ItemImageViewModel(id: $0.id ?? "", isSelected: false, imageUrl: $0.imageUrl ?? "") }
                    dispatch(ItemState.Action.loadImages(list: list))
                    
                }
            }
            next(action)
        }
    }
}
