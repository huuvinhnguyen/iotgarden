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
            
        case .updateSwitchItem(let switchCellViewModel):
            
            let indexItem = state.sectionItems.firstIndex {
                if case let .switchSectionItem(viewModel) = $0 {
                    return viewModel.uuid == switchCellViewModel.uuid
                }
                return false
            }
            
            if let index = indexItem  {
                state.sectionItems[index] = .switchSectionItem(viewModel: switchCellViewModel)
                state.identifiableComponent.update()
            }
            
            
        case .loadItems():
            
            
            let itemListService = ItemListService()
            itemListService.loadSensors { sensors in
                
                let items: [SectionItem] = sensors.compactMap { sensor in
                    
                    switch sensor.kind {
                    case "toggle":
                        return .switchSectionItem(viewModel: SwitchCellViewModel(sensor: sensor))
                        //                    case "temperature":
                        //                        return TemperatureDevice(sensor: sensor)
                        //                    case "humidity":
                        //                        return HumidityDevice(sensor: sensor)
                        //                    case "motion":
                    //                        return MotionDevice(sensor: sensor)
                    case "value":
                        return .valueSectionItem(viewModel: InputDevice(sensor: sensor))
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
