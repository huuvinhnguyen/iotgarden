//
//  AppState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 7/31/19.
//

import ReSwift

struct AppState: ReSwift.StateType {
    var itemState = ItemState()
    var topicState = TopicState()
    var connectionState = ConnectionState()
}
