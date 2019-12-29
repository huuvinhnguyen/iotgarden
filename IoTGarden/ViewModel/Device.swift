//
//  Device.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

enum Kind: String, EnumCollection {
    
    case temperature = "temperature"
    case humidity = "humidity"
    case toggle = "toggle"
    case motion = "motion"
}

protocol CellState {
    var cellType: CellType { get set }
}

extension CellState {
    var cellType: CellType {
        return .unknow
    }
}

enum CellType: String, EnumCollection {
    
    case temperature = "temperature"
    case humidity = "humidity"
    case toggle = "toggle"
    case motion = "motion"
    case unknow = "unknow"
}


protocol CellViewModel {
    var uuid: String? { get }
    var sensor: TopicToDo { get set }
    var sensorConnect: SensorConnect { get set }
}


extension CellViewModel {
    var uuid: String? {
        return sensor.uuid
    }
}


protocol Display {
    
    func display(cellViewModel: CellViewModel)
}

protocol CellUI {
    var message: String { get set }
}
