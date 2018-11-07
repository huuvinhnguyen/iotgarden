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
    return state
}
