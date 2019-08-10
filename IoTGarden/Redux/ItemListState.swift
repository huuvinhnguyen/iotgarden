//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT

//struct ItemListState {
//    
//    var items: [CellViewModel]
//    var sections: [ItemSectionModel] = []
//    var mqtt: CocoaMQTT?
//    var sensorConnect = SensorConnect2()
//    init(items: [CellViewModel]) {
//        self.items = items
//    }
//}


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
    
}

extension ListState {
    enum Action: ReSwift.Action {
        case requestSuccess(response: [CellViewModel])
        case switchItem(viewModel: SwitchCellViewModel)
        case updateSwitchItem(viewModel: SwitchCellViewModel)
        case loadItems()
        case loadDetail(id: String)
    }
}






let switchingMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in

            print("middleware action : \(action)")
            if case let ListState.Action.switchItem(viewModel: switchCellViewModel) = action {
                let state = getState()?.listState ?? ListState()
                switchCellViewModel.sensorConnect2.publish(message: switchCellViewModel.isOn ? "1" : "0")
                switchCellViewModel.sensorConnect2.didReceiveMessage = {  mqtt, message, id in
                    print("#mqtt message: \(message)")
                    print("#clienti = \(mqtt.clientID)")
                    switchCellViewModel.stateString = "Update"
                    switchCellViewModel.sensor.value = message.string ?? "0"
                    
                    if message.string == "1" {
                        
                        switchCellViewModel.isOn = true
                    }
                    
                    if message.string == "0" {
                        
                        switchCellViewModel.isOn = false
                    }
                    
                    if message.string == "done" {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateString = formatter.string(from: Date())
                        switchCellViewModel.timeString = dateString
                    }
                    
                    let action2 = ListState.Action.updateSwitchItem(viewModel: switchCellViewModel)
                    appStore.dispatch(action2)
                    
                    let itemListService = ItemListService()
                    itemListService.updateSensor(sensor: switchCellViewModel.sensor)
                }

            } else {
                return next(action)
            }
        }
    }
}

