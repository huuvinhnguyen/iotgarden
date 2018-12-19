//
//  ItemReducer.swift
//  IoTGarden
//
//  Created by Apple on 12/15/18.
//

import ReactiveReSwift
import RxSwift

let itemReducer: Reducer<ItemState> = { action, state in
    
    var state = state
    
    if let action = action as? UpdateItemAction {
        
        state.item = action.item
    }
    
    return state
}
