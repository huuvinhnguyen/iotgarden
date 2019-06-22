//
//  ItemDetailStore.swift
//  IoTGarden
//
//  Created by Apple on 6/22/19.
//

import ReSwift

let itemDetailStore = Store<ItemDetailState>(
    reducer: itemDetailReducer,
    state: nil
)
