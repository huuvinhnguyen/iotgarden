//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift

struct ItemListState {
    
    var items: [CellViewModel]
}


struct ItemState {
    
    var item: ToggleItem
}

struct SensorListState {
    
    let sensors: [Sensor]
}

struct SensorState {
    
    var sensor: Sensor
}
