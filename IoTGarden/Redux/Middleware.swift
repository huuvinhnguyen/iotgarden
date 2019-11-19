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
            if case ListState.Action.addItem(let viewModel) = action {
                    let service = ItemListService()
                service.addItem(item: ItemListService.ItemData(uuid: viewModel.uuid, name: viewModel.name, imageUrlString: viewModel.imageUrlString, topics:[])) { item in
                    
                    dispatch(ListState.Action.loadItems())
                }
            }
            
            if case ListState.Action.removeItem(let id ) = action {
                let itemListService = ItemListService()
                itemListService.removeItem(id: id) { _ in
                    dispatch(ListState.Action.loadItems())
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
                
                 var viewModels: [ItemImageViewModel] = getState()?.listState.itemImageViewModels.compactMap {
                    var viewModel = $0
                    viewModel.isSelected = false
                    return viewModel
                    } ?? []
                
                if let index = viewModels.firstIndex(where: {$0.id == id}) {
                    var viewModel = viewModels[index]
                    viewModel.isSelected = true
                    viewModels[index] = viewModel
                    dispatch(ListState.Action.loadImage(viewModel: viewModel))

                }
                
                dispatch(ListState.Action.loadImages(list: viewModels))
                
            }
            
            if case ListState.Action.fetchImages() = action {
                
                let service = FirebaseService()
                service.getItems { items in
                    
                    let list = items.map { ItemImageViewModel(id: $0.id ?? "", isSelected: false, imageUrl: $0.imageUrl ?? "") }
                    dispatch(ListState.Action.loadImages(list: list))
                    
                }
            }
            next(action)
        }
    }
}

let topicMiddleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
    
    return { next in
        print("enter detail middleware")
        return { action in
            if case TopicState.Action.addTopic() = action {
                let service = ItemListService()
                service.addTopic(topic: Topic(uuid: UUID().uuidString, name: "name", value: "0", serverUUID: "serverUUID", kind: "kind", topic: "topic", time: "waiting")) { item in
                    dispatch(TopicState.Action.loadTopics())
                }
            }
            
            if case TopicState.Action.removeTopic(let id) = action {
                let service = ItemListService()
                service.removeTopic(id: id)
                dispatch(TopicState.Action.loadTopics())
            }
        
            next(action)
        }
    }
}

let connectionMiddleware: ReSwift.Middleware<AppState> = {  dispatch, getState in
    
    return { next in
        print("enter detail middleware")
        return { action in
            if case ConnectionState.Action.addConnection(let viewModel) = action {
                let service = ItemListService()
                service.addConfiguration(configuration: ItemListService.Configuration(uuid: viewModel.id, name: viewModel.name, server: viewModel.server, username: "", password: "", port: ""), finished: { id in
                    
                    dispatch(ConnectionState.Action.loadConnections())
                })
            }
            
            if case ConnectionState.Action.removeConnection(let id) = action {
                let service = ItemListService()
//                service.removeTopic(id: id)
//                dispatch(TopicState.Action.loadTopics())
            }
            
            next(action)
        }
    }
}
