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
    private var cellViewModels: [CellViewModel] = []
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = SubscriptionReferenceBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        listsenToPublisher()
        prepareNibs()
        configureRefreshControl()
        updateViewModel()
        
        loadItems()

        
//        navigationBar.observe(navigationItem)
    }
    
    private func listsenToPublisher() {
        
        disposeBag += itemListStore.observable.asObservable().subscribe{ [weak self] state in
            
            if let weakSelf = self {
                weakSelf.cellViewModels = state.items
                weakSelf.itemListCollectionView.reloadData()
                weakSelf.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateViewModel() {
        
        disposeBag += sensorStore.observable.asObservable().map { $0.sensor }.subscribe { [weak self] sensor in
            print("#itemState")
            guard let weakSelf = self else { return }
            let row = weakSelf.cellViewModels.index { $0.sensor.uuid == sensor.uuid }
            
            guard let rowIndex = row else { return }
            
                weakSelf.cellViewModels[rowIndex].sensor = sensor
                weakSelf.itemListCollectionView.reloadItems(at: [IndexPath(row: rowIndex, section: 0)])
        }
    }
    
    private func prepareNibs() {
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")

        itemListCollectionView.register(UINib(nibName: "TemperatureCell", bundle: nil), forCellWithReuseIdentifier: "TemperatureCell")
        
        itemListCollectionView.register(UINib(nibName: "HumidityCell", bundle: nil), forCellWithReuseIdentifier: "HumidityCell")
        
        itemListCollectionView.register(UINib(nibName: "MotionCell", bundle: nil), forCellWithReuseIdentifier: "MotionCell")
        
        itemListCollectionView.register(UINib(nibName: "ItemInputValueCell", bundle: nil), forCellWithReuseIdentifier: "ItemInputValueCell")
    }
    
    @objc private func loadItems() {
        
        itemListStore.dispatch(ListItemsAction())
    }
    
    private func configureRefreshControl() {
        
        itemListCollectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(loadItems), for: .valueChanged)
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
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellViewModel = cellViewModels[indexPath.row]
        let cell = CellCreator.create(cellAt: indexPath, with: cellViewModel, collectionView: collectionView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellViewModel = cellViewModels[indexPath.row]

        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        if let itemDetailViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailViewController") as? ItemDetailViewController {
            itemDetailViewController.sensor = cellViewModel.sensor
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
        
        
//        let storyboard = UIStoryboard(name: "ItemDetailTempViewController", bundle: nil)
//        if let itemDetailTempViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailTempViewController") as? ItemDetailTempViewController {
//
//            navigationController?.pushViewController(itemDetailTempViewController, animated: true)
//        }
        
//        let def = ItemDef(title: "Half Pie Chart",
//                subtitle: "This demonstrates how to create a 180 degree PieChart.",
//                class: BarChartViewController.self)
//        
//        let vcClass = def.class as! BarChartViewController.Type
//        let vc = vcClass.init()
//        vc.sensor = device.sensor
//        
//        navigationController?.pushViewController(vc, animated: true)
    }
}
