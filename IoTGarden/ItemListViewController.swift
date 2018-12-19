//
//  ItemListViewController.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit
import ReactiveReSwift

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    private let itemListService = ItemListService()
    private var itemListCellViewModels: [ItemListCellViewModel] = []
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = SubscriptionReferenceBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        configureRefreshControl()
        
        disposeBag += itemStore.observable.asObservable().map { $0.item }.subscribe { [weak self] item in
            print("#itemState")
            guard let weakSelf = self else { return }
            let row = weakSelf.itemListCellViewModels.index { $0.item.uuid == item.uuid }
            
            guard let rowIndex = row else { return }
            
            let currentViewModel = weakSelf.itemListCellViewModels[rowIndex]
            
            if currentViewModel.item.isOn != item.isOn {
                
                weakSelf.itemListCellViewModels[rowIndex].item = item
                weakSelf.itemListCollectionView.reloadItems(at: [IndexPath(row: rowIndex, section: 0)])
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        loadItems()
    }
    
    private func prepareNibs() {
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")
    }
    
    @objc private func loadItems() {
        
        disposeBag += itemListStore.observable.asObservable().subscribe { [weak self] itemListState in
            
            print("#asObservable: list")
            if let weakSelf = self {
                
                weakSelf.itemListService.loadLocalItems { items in
                    weakSelf.itemListCellViewModels = items.map { ItemListCellViewModel(item: $0) }
                    weakSelf.itemListCollectionView.reloadData()
                    weakSelf.refreshControl.endRefreshing()
                }
            }
        }
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
        
        return itemListCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell",
                                                      for: indexPath) as! ItemListCell
        let itemListCellViewModel = itemListCellViewModels[indexPath.row]

        cell.display(viewModel: itemListCellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModelCell = itemListCellViewModels[indexPath.row]
        
        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        if let itemDetailViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailViewController") as? ItemDetailViewController {
            itemDetailViewController.item = viewModelCell.item
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
}
