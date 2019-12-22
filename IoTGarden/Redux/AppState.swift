//
//  AppState.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 7/31/19.
//

import ReSwift
import ReSwiftRouter

struct AppState: ReSwift.StateType {
    var navigationState: NavigationState = NavigationState()
    var itemState = ItemState()
    var topicState = TopicState()
    var connectionState = ConnectionState()
}
