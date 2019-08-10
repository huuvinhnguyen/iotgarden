//
//  ItemDetailAction.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 6/19/19.
//

import ReSwift

struct LoadItemDetail: Action {
    
    let sensorUUID: String
}

extension ItemDetailState {
    
    enum Action: ReSwift.Action {
        case loadDetail(id: String)
    }
}
