//
//  FirebaseService.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//
import Firebase


class FirebaseService {
    
    
    let db = Firestore.firestore()
    
    struct Collection {
        var items: [Item]
        init(dictionary: [String: Any]?) {
            let dicts = dictionary?["items"] as? [[String : Any]] ?? []
            items = dicts.map { Item(dictionary: $0) }
        }
    }

    
    struct Item {
        var id: String?
        var name: String?
        var imageUrl: String?
        
        init(dictionary: [String: Any]?) {
            id = dictionary?["id"] as? String
            name = dictionary?["name"] as? String
            imageUrl = dictionary?["imageUrl"] as? String
        }
    }
    
    func getItems(finished: @escaping (_ items: [Item])->()) {
        
        db.collection("items").document("list")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                let collection = Collection(dictionary: data)
        
                finished(collection.items)
                
        }
    }
}
