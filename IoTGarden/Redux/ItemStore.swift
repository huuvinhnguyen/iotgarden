//
//  ItemStore.swift
//  IoTGarden
//
//  Created by Apple on 12/15/18.
//

import RxSwift
import ReactiveReSwift

let itemMiddleware = Middleware<ItemState>().sideEffect { _, _, action in
    print("Received action:")
    }.map { _, action in
        print(action)
        return action
}

let itemStore = Store(
    
    reducer: itemReducer,
    observable: Variable(ItemState(item:ToggleItem())),
    middleware: itemMiddleware
)

let sensorMiddleware = Middleware<SensorState>().sideEffect { _, _, action in
    print("Received action:")
    }.map { _, action in
        print(action)
        return action
}

let sensorStore = Store(
    
    reducer: sensorReducer,
    observable: Variable(SensorState(sensor:Sensor())),
    middleware: sensorMiddleware
)
