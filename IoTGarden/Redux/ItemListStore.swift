//
//  ItemListStore.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import RxSwift
import ReactiveReSwift

let itemListMiddleware = Middleware<ItemListState>().sideEffect { _, _, action in
    print("Received action:")
    }.map { _, action in
        print(action)
        return action
}

let itemListStore = Store(
    
    reducer: itemListReducer,
    observable: Variable(ItemListState(items:[])),
    middleware: itemListMiddleware
)

let sensorListMiddleware = Middleware<SensorListState>().sideEffect { _, _, action in
    print("Received action:")
    }.map { _, action in
        print(action)
        return action
}

let sensorListStore = Store(
    
    reducer: sensorListReducer,
    observable: Variable(SensorListState(sensors:[])),
    middleware: sensorListMiddleware
)
