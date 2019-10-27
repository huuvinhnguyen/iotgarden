//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT

struct ItemState {
    
    var item: ToggleItem
}

struct SensorListState {
    
    let sensors: [Sensor]
}

struct SensorState {
    
    var sensor: Sensor
}

import ReSwift
struct ListState: ReSwift.StateType, Identifiable {
    
    var identifiableComponent = IdentifiableComponent()
    
    var sections: [ItemSectionModel] = []
    var sectionItems: [SectionItem] = []
    var tasks: [String: SensorConnect2] = [:]
    
}

extension ListState {
    enum Action: ReSwift.Action {
        case switchItem(cellUI: SwitchCellUI, message: String)
        case inputItem(cellUI: InputCellUI, message: String)
        case updateSwitchItem(viewModel: SwitchCellUI)
        case updateInputItem(cellUI: InputCellUI)

        case loadItems()
        case addItem()
        case loadDetail(id: String)
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


