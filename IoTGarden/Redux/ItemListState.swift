//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift
import CocoaMQTT

struct ItemListState {
//    static func == (lhs: ItemListState, rhs: ItemListState) -> Bool {
//        return true
//
//    }
    
    
    var items: [CellViewModel]
    var sections: [ItemSectionModel] = []
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

import ReSwift

struct AppState: ReSwift.StateType {
    var listState = ListState()
}

struct ListState: ReSwift.StateType, Identifiable {
    
    fileprivate(set) var identifiableComponent = IdentifiableComponent()
    
    var sensorConnect = SensorConnect2()
    var sections: [ItemSectionModel] = []
    var sectionItems: [SectionItem] = []
    
}

extension ListState {
    enum Action: ReSwift.Action {
        case requestSuccess(response: [CellViewModel])
        case switchItem(viewModel: SwitchCellViewModel)
        case updateSwitchItem(viewModel: SwitchCellViewModel)

        case loadItems()
    }
}


extension ListState {
    
    public static func reducer(action: ReSwift.Action, state: ListState?) -> ListState {
    
        var state = state ?? ListState()
        
        guard let action = action as? ListState.Action else { return state }
        switch action {
            
        case .updateSwitchItem(let switchCellViewModel):
          
            let indexItem = state.sectionItems.firstIndex {
                if case let .switchSectionItem(viewModel) = $0 {
                    return viewModel.uuid == switchCellViewModel.uuid
                }
                return false
            }
            
            
            
            if let index = indexItem  {
                print("#index: \(index)")
                print("#id = \(switchCellViewModel.uuid)")
                state.sectionItems[index] = .switchSectionItem(viewModel: switchCellViewModel)
                state.identifiableComponent.update()
            }
           
            
            
//        case .switchItem(let switchCellViewModel):
//
////            state.sensorConnect.connect(sensor: switchCellViewModel.sensor)
////            state.sensorConnect.publish(message: "1")
////            state.sensorConnect.didReceiveMessage = {  mqtt, message, id in
////                print("#mqtt message: \(message)")
////                print("#clienti = \(mqtt.clientID)")
////            }
//
//            let indexItem = state.sectionItems.firstIndex {
//                if case let .switchSectionItem(viewModel) = $0 {
//                    return viewModel.identity == switchCellViewModel.identity && viewModel.isOn != switchCellViewModel.isOn
//                }
//                return false
//            }
//
//            guard let index = indexItem else { break }
//            state.sectionItems[index] = .switchSectionItem(viewModel: switchCellViewModel)
//            state.identifiableComponent.update()

            
        case .loadItems():

            
            let itemListService = ItemListService()
            itemListService.loadSensors { sensors in
                
                    let items: [SectionItem] = sensors.compactMap { sensor in
                    
                    switch sensor.kind {
                    case "toggle":
                        return .switchSectionItem(viewModel: SwitchCellViewModel(sensor: sensor))
//                    case "temperature":
//                        return TemperatureDevice(sensor: sensor)
//                    case "humidity":
//                        return HumidityDevice(sensor: sensor)
//                    case "motion":
//                        return MotionDevice(sensor: sensor)
                    case "value":
                        return .valueSectionItem(viewModel: InputDevice(sensor: sensor))
                    default:
                        return nil
                    }
                }
                
                state.sectionItems = items

                
                let sections: [ItemSectionModel] = [ .itemSection(title: "", items: state.sectionItems)]
                state.sections = sections
                state.identifiableComponent.update()
            }
            
        default: ()
        }
        
        return state
    }
}

func appReduce(action: ReSwift.Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.listState = ListState.reducer(
        action: action,
        state: state.listState)
    
    return state
}

var appStore = ReSwift.Store<AppState>(
    reducer: appReduce,
    state: nil,
    middleware: [loggingMiddleware  ])

let loggingMiddleware: ReSwift.Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in

            print("middleware action : \(action)")
            if case let ListState.Action.switchItem(viewModel: switchCellViewModel) = action {
                let state = getState()?.listState ?? ListState()
                switchCellViewModel.sensorConnect2.connect(sensor: switchCellViewModel.sensor)
                switchCellViewModel.sensorConnect2.publish(message: switchCellViewModel.isOn ? "1" : "0")
                switchCellViewModel.sensorConnect2.didReceiveMessage = {  mqtt, message, id in
                    print("#mqtt message: \(message)")
                    print("#clienti = \(mqtt.clientID)")
                    switchCellViewModel.stateString = "Update"
                    
                    if message.string == "done" {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateString = formatter.string(from: Date())
                        switchCellViewModel.timeString = dateString
                    }
                    
                    let action2 = ListState.Action.updateSwitchItem(viewModel: switchCellViewModel)
                    appStore.dispatch(action2)
                }

                
            } else {
                return next(action)
            }
        }
    }
}


struct IdentifiableComponent : Hashable {
    
    typealias Identifier = UInt64

    private struct Counter {
        static let lock = DispatchSemaphore(value: 1)
        static var count: Identifier = 0
        static func getAndIncrement() -> Identifier {
            lock.wait()
            defer { lock.signal() }
            count += 1
            return count
        }
    }
    
    private(set) var identifier: Identifier = Counter.getAndIncrement()
    
    var hashValue: Int { return identifier.hashValue }
    
    mutating func update() {
        identifier = Counter.getAndIncrement()
    }
}

protocol HasIdentifiableComponent : Equatable {
    var identifiableComponent: IdentifiableComponent { get }
}

protocol Identifiable : HasIdentifiableComponent {
}

extension Identifiable {
    
    var identifier: IdentifiableComponent.Identifier {
        return identifiableComponent.identifier
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifiableComponent == rhs.identifiableComponent
    }
}
