//
//  ItemDetailReducer.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 6/17/19.
//

import ReSwift

let itemDetailReducer: Reducer<ItemDetailState> = { action, state in
    
    var state = state ?? ItemDetailState()
    
    if let action = action as? LoadItemDetail {
        
        let itemListService = ItemListService()
        let sensor = itemListService.getSensor(uuid: action.sensorUUID)
        state.name = sensor?.name ?? ""
        state.value = sensor?.value ?? ""
        state.kind = sensor?.kind ?? ""
        state.topic = sensor?.topic ?? ""
        state.time = sensor?.time ?? ""
    }
    
    return state
}


