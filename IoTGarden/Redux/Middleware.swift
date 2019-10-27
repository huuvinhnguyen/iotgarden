//
//  Middleware.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/27/19.
//

import ReSwift

let itemListMiddleware: ReSwift.Middleware<ItemDetailState> = {  dispatch, getState in
    
    return { next in
        print("enter detail middleware")
        return { action in
            if case let ListState.Action.addItem() = action {
                let service = ItemListService()
                service.addItem(item: ItemListService.ItemData(uuid: UUID().uuidString, name: "item1", imageUrlString: "http://", topics:[])) { item in
                    
                    dispatch(ListState.Action.loadItems())
                }
                
            }

            next(action)
        }
    }
}
