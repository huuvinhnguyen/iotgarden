//
//  ItemImageViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//

import UIKit
import RxSwift
import RxCocoa

class ItemImageViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(configureCell: { dataSource, collectionView, indexPath, _ in
        switch dataSource[indexPath] {
        case .imageSectionItem(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImageCell
            return cell
        }
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNibs()
        
        let sections: [SectionModel] = [
        .itemSection(title: "1", items: [
            .imageSectionItem(viewModel: ItemImageViewModel()),
            .imageSectionItem(viewModel: ItemImageViewModel()),
            .imageSectionItem(viewModel: ItemImageViewModel())
            ]),
           
            
           
        ]
        
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func prepareNibs() {
        collectionView.register(UINib(nibName: "ItemImageCell", bundle: nil), forCellWithReuseIdentifier: "ItemImageCell")
    }
    
}

import RxDataSources

extension ItemImageViewController {
    
    enum SectionModel {
        case itemSection(title: String, items: [SectionItem])
    }
    
    enum SectionItem {
        case imageSectionItem(viewModel: ItemImageViewModel)
    }
}

extension ItemImageViewController.SectionModel: SectionModelType {
    
    typealias Item = ItemImageViewController.SectionItem
    init(original: ItemImageViewController.SectionModel, items: [Item]) {
        switch original {
        case let .itemSection(title: title, items: items):
            self = .itemSection(title: title, items: items)
        }
    }
    
    var items: [ItemImageViewController.SectionItem] {
        switch self {
        case .itemSection(title: _, items: let items):
            return items.map {$0}
        }
    }
}

