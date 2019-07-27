//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT

struct ItemListState {
    
    var items: [CellViewModel]
    var mqtt: CocoaMQTT?
    var sensorConnect = SensorConnect2()
    init(items: [CellViewModel]) {
        self.items = items
    }
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
