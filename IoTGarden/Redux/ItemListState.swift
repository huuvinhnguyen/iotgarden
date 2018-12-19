//
//  ItemListState.swift
//  IoTGarden
//
//  Created by Apple on 11/4/18.
//

import ReactiveReSwift

struct ItemListState {
    
    let items: [Item]
}

struct ItemListCellViewModelState {
    let itemListCellViewModel: ItemListCellViewModel
}

struct ItemState {
    
    var item: ToggleItem
}
