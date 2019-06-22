//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Apple on 11/1/18.
//

import UIKit
import CoreData
import ReSwift

class ItemDetailViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func newState(state: ItemDetailState) {
        
        nameLabel.text = state.name
        valueLabel.text = state.value
        kindLabel.text = state.kind
        topicLabel.text = state.topic
        timeLabel.text = state.time
    }
    
    
    typealias StoreSubscriberStateType = ItemDetailState
    
    var sensor = Sensor()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        itemDetailStore.subscribe(self)
        itemDetailStore.dispatch(LoadItemDetail(sensorUUID: sensor.uuid))

    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        
        print("Value changed")
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let itemListService = ItemListService()
        itemListService.removeSensor(sensor: sensor)
        itemListStore.dispatch(AddSensorAction())
        navigationController?.popViewController(animated: true)
    }
}
