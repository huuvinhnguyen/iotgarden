//
//  ItemData.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 1/2/20.
//

extension ItemListService {
    
    struct ItemData {
        let uuid: String
        let name: String
        let imageUrlString: String
        var topics: [String]?
    }
    
    func loadItems(finished: (_ items: [ItemData])->()) {
        let interactor = ItemDataInteractor()
        interactor.getItems { items in
            finished(items)
        }
    }
    
    func loadItem(id: String, finished: (_ item: ItemData?)->()) {
        let interactor = ItemDataInteractor()
        interactor.getItem(uuid: id) { item in
            finished(item)
        }
    }
    
    func addItem(item: ItemData, finished: (_ item: ItemData)->()) {
        let interactor = ItemDataInteractor()
        interactor.add(item: item) { itemData in
            finished(itemData)
        }
    }
    
    func removeItem(id: String, finished: (_ id: String)->()) {
        let interactor = ItemDataInteractor()
        interactor.delete(id: id) { finished($0) }
        
    }
    
    func updateItem(item: ItemData, finished: (_ item: ItemData)->()) {
        let interactor = ItemDataInteractor()
        interactor.update(item: item) { _ in
            finished(item)
        }
        
    }
}
