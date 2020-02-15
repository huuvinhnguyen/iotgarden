//
//  Topic.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 12/29/19.
//

struct Topic {
    var id = ""
    var name = ""
    var topic = ""
    var value = ""
    var time = ""
    var serverId = ""
    var type = ""
    var qos = ""
    var message = ""
    var retain = ""
    var itemId = ""
}

extension Topic: Equatable {
    typealias Identity = String
    var identity: String { return id }
    
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.topic == rhs.topic &&
        lhs.value == rhs.value &&
        lhs.time == rhs.time &&
        lhs.serverId == rhs.serverId &&
        lhs.type == rhs.type &&
        lhs.qos == rhs.qos &&
        lhs.message == rhs.message
        lhs.retain == rhs.retain

    }
}
