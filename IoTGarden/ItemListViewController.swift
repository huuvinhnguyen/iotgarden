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
    fileprivate var items = [Item]()
    private let itemListService = ItemListService()
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = SubscriptionReferenceBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        configureRefreshControl()
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        itemListCollectionView.reloadData()        
    }
    
    private func prepareNibs() {
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")
    }
    
    @objc private func loadItems() {
        
        disposeBag += itemListStore.observable.asObservable().subscribe { [weak self] itemListState in
            
            if let weakSelf = self {
                
                weakSelf.itemListService.loadLocalItems { items in
                    weakSelf.items = items
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
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell",
                                                      for: indexPath) as! ItemListCell
        let item = items[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        let storyboard = UIStoryboard(name: "ItemDetailViewController", bundle: nil)
        if let itemDetailViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailViewController") as? ItemDetailViewController {
            itemDetailViewController.item = item
            navigationController?.pushViewController(itemDetailViewController, animated: true)
        }
    }
}
