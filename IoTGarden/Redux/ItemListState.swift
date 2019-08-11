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

struct AppState: ReSwift.StateType {
    var listState = ListState()
    var detailState = ItemDetailState()
}

struct ListState: ReSwift.StateType, Identifiable {
    
    var identifiableComponent = IdentifiableComponent()
    
    var sensorConnect = SensorConnect2()
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
                    
                    if message.string == "1" {
                        
                        switchCellUI.isOn = true
                    }
                    
                    if message.string == "0" {
                        
                        switchCellUI.isOn = false
                    }
                    switchCellUI.message = message.string ?? ""
                    let action2 = ListState.Action.updateSwitchItem(viewModel: switchCellUI)
                    appStore.dispatch(action2)
                    
//                    let itemListService = ItemListService()
//                    itemListService.updateSensor(sensor: switchCellViewModel.sensor)
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
                    
                    
                    let action2 = ListState.Action.updateInputItem(cellUI: inputCellUI)
                    appStore.dispatch(action2)
                    
                    //                    let itemListService = ItemListService()
                    //                    itemListService.updateSensor(sensor: switchCellViewModel.sensor)
                }
                
            } else {
                return next(action)
            }
        }
    }
}


