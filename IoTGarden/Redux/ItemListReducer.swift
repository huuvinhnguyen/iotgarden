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
    
    return state
}

let sensorListReducer: Reducer<SensorListState> = { action, state in
    
    var state = state
    
    
    if let action = action as? AddSensorAction {
        //        state.clouds.append(action.cloud)
    }
    
    return state
}
