//
//  ItemAction.swift
//  IoTGarden
//
//  Created by Apple on 12/15/18.
//

import ReactiveReSwift

struct UpdateItemAction: Action {
    
    let item: ToggleItem
}

struct UpdateSensorAction: Action {
    
    let sensor: Sensor
}
