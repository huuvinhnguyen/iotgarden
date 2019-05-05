//
//  ItemListViewController.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit
import ReactiveReSwift
import MaterialComponents.MaterialNavigationBar

private struct ItemDef {
    let title: String
    let subtitle: String
    let `class`: AnyClass
}

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    private let itemListService = ItemListService()
    private var devices: [Device] = []
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = SubscriptionReferenceBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        configureRefreshControl()
        updateViewModel()
        
        loadSensors()

        
//        navigationBar.observe(navigationItem)
    }
    
    func updateViewModel() {
        
        disposeBag += sensorStore.observable.asObservable().map { $0.sensor }.subscribe { [weak self] sensor in
            print("#itemState")
            guard let weakSelf = self else { return }
            let row = weakSelf.devices.index { $0.sensor.uuid == sensor.uuid }
            
            guard let rowIndex = row else { return }
            
//            let currentViewModel = weakSelf.devices[rowIndex]
            
//            if currentViewModel.sensor.value != sensor.value {
            
                weakSelf.devices[rowIndex].sensor = sensor
                weakSelf.itemListCollectionView.reloadItems(at: [IndexPath(row: rowIndex, section: 0)])
//            }
        }
    }
    
    private func prepareNibs() {
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")
        
        itemListCollectionView.register(UINib(nibName: "TemperatureCell", bundle: nil), forCellWithReuseIdentifier: "TemperatureCell")
        
        itemListCollectionView.register(UINib(nibName: "HumidityCell", bundle: nil), forCellWithReuseIdentifier: "HumidityCell")
        
        itemListCollectionView.register(UINib(nibName: "MotionCell", bundle: nil), forCellWithReuseIdentifier: "MotionCell")
    }
    
    @objc private func loadSensors() {
        
        disposeBag += sensorListStore.observable.asObservable().subscribe { [weak self] sensorListState in
            
            print("#asObservable: list")
            if let weakSelf = self {
                
                weakSelf.itemListService.loadSensors { sensors in
                    
                    weakSelf.devices = sensors.compactMap { sensor in
                        
                        switch sensor.kind {
                        case "toggle":
                            return SwitchDevice(sensor: sensor)
                        case "temperature":
                            return TemperatureDevice(sensor: sensor)
                        case "humidity":
                            return HumidityDevice(sensor: sensor)
                        case "motion":
                            return MotionDevice(sensor: sensor)
                        default:
                            return nil
                        }
                    }
                    
                    weakSelf.itemListCollectionView.reloadData()
                    weakSelf.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func configureRefreshControl() {
        
        itemListCollectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(loadSensors), for: .valueChanged)
        itemListCollectionView.addSubview(refreshControl)
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "AddItemViewController", bundle: nil)
        if let addItemViewController = storyboard.instantiateViewController(withIdentifier :"AddItemViewController") as? AddItemViewController {
            
            navigationController?.pushViewController(addItemViewController, animated: true)
        }
    }
    
    @IBAction func tempButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ItemDetailTempViewController", bundle: nil)
        if let itemDetailTempViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailTempViewController") as? ItemDetailTempViewController {
            
            navigationController?.pushViewController(itemDetailTempViewController, animated: true)
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let device = devices[indexPath.row]
        let cell = CellCreator.create(cellAt: indexPath, with: device, collectionView: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let device = devices[indexPath.row]
//        
//        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
//        if let itemDetailViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailViewController") as? ItemDetailViewController {
//            itemDetailViewController.sensor = device.sensor
//            navigationController?.pushViewController(itemDetailViewController, animated: true)
//        }
        
        
//        let storyboard = UIStoryboard(name: "ItemDetailTempViewController", bundle: nil)
//        if let itemDetailTempViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailTempViewController") as? ItemDetailTempViewController {
//
//            navigationController?.pushViewController(itemDetailTempViewController, animated: true)
//        }
        
        let def = ItemDef(title: "Half Pie Chart",
                subtitle: "This demonstrates how to create a 180 degree PieChart.",
                class: LineChart3ViewController.self)
        
        let vcClass = def.class as! UIViewController.Type
        let vc = vcClass.init()
        
        navigationController?.pushViewController(vc, animated: true)

        
        
    }
}
