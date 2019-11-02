//
//  ItemImageViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/31/19.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ItemImageViewController: UIViewController,  StoreSubscriber {
    
    func newState(state: ListState) {
        
    }
    
    private let disposeBag = DisposeBag()

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(configureCell: { dataSource, collectionView, indexPath, _ in
        switch dataSource[indexPath] {
        case .imageSectionItem(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImageCell
            cell.viewModel = viewModel
            return cell
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNibs()
        
        appStore.subscribe(self) { $0.select { $0.listState }.skipRepeats() }
        
        let action = ListState.Action.fetchImages()
        appStore.dispatch(action)

        let sections: [SectionModel] = [
        .itemSection(title: "1", items: [
            .imageSectionItem(viewModel: ItemImageViewModel(id: "0", isSelected: true, imageUrl: "")),
            .imageSectionItem(viewModel: ItemImageViewModel(id: "1", isSelected: false, imageUrl: "")),
            .imageSectionItem(viewModel: ItemImageViewModel(id: "2", isSelected: false, imageUrl: ""))
            ])
        ]
        
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(SectionItem.self).subscribe(onNext: { sectionItem in
            if case  SectionItem.imageSectionItem(let viewModel) = sectionItem {
                appStore.dispatch(ListState.Action.selectImage(id: viewModel.id))
            }
            
        }).disposed(by: disposeBag)
        
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

