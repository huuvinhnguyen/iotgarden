//
//  ItemListReducer.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift
import RxSwift

let itemListReducer: Reducer<ItemListState> = { action, state in
    
    var state = state
    
    if let action = action as? AddItemAction {
//        state.clouds.append(action.cloud)
    }
    
    if let action = action as? ListItemsAction {
        
        let itemListService = ItemListService()
        itemListService.loadSensors { sensors in
            
            state.items = sensors.compactMap { sensor in
                
                switch sensor.kind {
                case "toggle":
                    return SwitchCellViewModel(sensor: sensor)
                case "temperature":
                    return TemperatureDevice(sensor: sensor)
                case "humidity":
                    return HumidityDevice(sensor: sensor)
                case "motion":
                    return MotionDevice(sensor: sensor)
                case "value":
                    return InputDevice(sensor: sensor)
                default:
                    return nil
                }
            }
        }
        
    }
    
    if let action = action as? ListItemsAction2 {
        
        let itemListService = ItemListService()
        itemListService.loadSensors { sensors in
            
            let items: [SectionItem] = sensors.compactMap { sensor in
                
                switch sensor.kind {
                case "toggle":
                    return .switchSectionItem(viewModel: SwitchCellViewModel(sensor: sensor))
                case "value":
                    return .valueSectionItem(viewModel: InputDevice(sensor: sensor))
                default:
                    return nil
                }
                
            }
            
            state.sections = [ .itemSection(title: "", items: items)]
        }
        
    }
    
    if let action = action as? ItemListUpdateItemAction {
        
        for i in 0..<state.items.count {
            if state.items[i].uuid == "abc" {
                let item = state.items[i]
            }
        }
    }
    
    if let action = action as? ItemListUpdateFromMQTTAction {
        
        
        for i in 0..<state.items.count {
            print("#uuid: \(state.items[i].uuid)" )
            if state.items[i].uuid == action.uuid {
                print("#uuid exists")
                
                let item = state.items[i]
                if let switchCellViewModel = item as? SwitchCellViewModel {
                    
                    if action.message == "1" { switchCellViewModel.isOn = true }
                    if action.message == "0" { switchCellViewModel.isOn = false }
                    state.items[i] = switchCellViewModel
                }
            }
        }
    }
    
    if let action = action as? ItemListPublishMQTTAction {
        print("##ItemListPublishMQTTAction")
//        if state.sensorConnect != nil {
//            state.sensorConnect.disconnect()
//        }
        
        state.sensorConnect = action.sensorConnect
        
    }
    
    return state
}

let sensorListReducer: Reducer<SensorListState> = { action, state in
    
    var state = state
    

    if let action = action as? AddSensorAction {
        //        state.clouds.append(action.cloud)
    }
    
    return state
}
