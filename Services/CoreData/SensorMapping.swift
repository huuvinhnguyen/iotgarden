//
//  SensorMapping.swift
//  IoTGarden
//
//  Created by Apple on 12/19/18.
//

import CoreData

protocol  SensorMapping {
    
    func add(item: Item ) -> ()
    func delete(uuid: String) -> ()
    func update(item: Item) -> ()
    func getItem(uuid: String) -> Item?
}

extension SensorMapping {
    
    func delete(uuid: String) {
        
        
    }
}


protocol A {
    
    associatedtype B
}

struct C: A {
    typealias B = C
}

struct Mapping<T: Item> {
    
    
    fileprivate let _observer: T

    init(item: T) {
        
        _observer = item
    }
    func map() -> [T] {
        
        return []
    }
}
