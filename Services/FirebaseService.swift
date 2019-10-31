//
//  FirebaseService.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//

class FirebaseService {
    
    struct Item {
        let imageUrl: String
        let name: String
    
    }
    
    func getItems(finished: (_ items: [Item])->()) {
        
        let items = [Item(imageUrl: "abc", name: "hello aaa"),
                     Item(imageUrl: "abc", name: "hello aaa")
        ]
        
        finished(items)
    }
}
