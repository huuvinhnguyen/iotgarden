//
//  ItemListReducer.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/4/18.
//

import ReSwift

extension ListState {
    
    public static func reducer(action: ReSwift.Action, state: ListState?) -> ListState {
        
        var state = state ?? ListState()
        
        guard let action = action as? ListState.Action else { return state }
        switch action {
            
        case .updateSwitchItem(let switchCellUI):
            
            let indexItem = state.sectionItems.firstIndex {
                if case let .switchSectionItem(cellUI) = $0 {
                    return cellUI.uuid == switchCellUI.uuid
                }
                return false
            }
            
            if let index = indexItem  {
                
                state.sectionItems[index] = .switchSectionItem(cellUI: switchCellUI)
                state.identifiableComponent.update()
            }
            
        case .updateInputItem(let inputCellUI):
            
            let indexItem = state.sectionItems.firstIndex {
                if case let .inputSectionItem(cellUI) = $0 {
                    return cellUI.uuid == inputCellUI.uuid
                }
                return false
            }
            
            if let index = indexItem  {
                state.sectionItems[index] = .inputSectionItem(cellUI: inputCellUI)
                state.identifiableComponent.update()
            }

            
        case .loadItems():
            
            let itemListService = ItemListService()
            itemListService.loadSensors { sensors in
                
                let items: [SectionItem] = sensors.compactMap { sensor in
                    
                    switch sensor.kind {
                    case "toggle":
                        
                        let task = SensorConnect2()
                        task.connect(sensor: sensor)
                        state.tasks[sensor.uuid] = task
                        let switchCellUI = SwitchCellUI(uuid: sensor.uuid, name: sensor.name, stateString: "Updated", timeString: sensor.time, message: sensor.value )
                        
                        return .switchSectionItem(cellUI: switchCellUI)
                        //                    case "temperature":
                        //                        return TemperatureDevice(sensor: sensor)
                        //                    case "humidity":
                        //                        return HumidityDevice(sensor: sensor)
                        //                    case "motion":
                    //                        return MotionDevice(sensor: sensor)
                    case "value":
                        let task = SensorConnect2()
                        task.connect(sensor: sensor)
                        state.tasks[sensor.uuid] = task
                        let inputCellUI = InputCellUI(uuid: sensor.uuid, name: sensor.name, stateString: "Updated", timeString: sensor.time, message: sensor.value)
                        return .inputSectionItem(cellUI: inputCellUI)
                    default:
                        return nil
                    }
                }
                
                state.sectionItems = items
                
                
                let sections: [ItemSectionModel] = [ .itemSection(title: "", items: state.sectionItems)]
                state.sections = sections
                state.identifiableComponent.update()
            }
            
        default: ()
        }
        
        return state
    }
}
