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
    
    func newState(state: ItemState) {
        imagesRelay.accept(state.images)
    }
    
    @IBAction func didSaveButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        appStore.dispatch(ItemState.Action.updateItemImage(imageUrl: imageUrl))

    }
    private let disposeBag = DisposeBag()

    private var sections = PublishRelay<[SectionModel]>()
    private var imagesRelay = PublishRelay<[Image]>()
    private var imageUrl = ""



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
        
        appStore.subscribe(self) { $0.select { $0.itemState }.skipRepeats() }
        
        imagesRelay.asObservable()
            .map { $0.map { SectionItem.imageSectionItem(viewModel: ItemImageCell.ViewModel(id: $0.id, isSelected: $0.isSelected, imageUrl: $0.imageUrl)) } }
            .map { sectionItems -> [SectionModel]  in
                return [SectionModel.itemSection(title: "1", items: sectionItems)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        let action = ItemState.Action.fetchImages()
        appStore.dispatch(action)

        
        collectionView.rx.modelSelected(SectionItem.self).subscribe(onNext: { [weak self] sectionItem in
            if case  SectionItem.imageSectionItem(let viewModel) = sectionItem {
                appStore.dispatch(ItemState.Action.selectImage(id: viewModel.id))
                guard let weakSelf = self else { return }
                weakSelf.imageUrl = viewModel.imageUrl
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func prepareNibs() {
        collectionView.register(UINib(nibName: "ItemImageCell", bundle: nil), forCellWithReuseIdentifier: "ItemImageCell")
    }
}

import RxDataSources

extension ItemImageViewController {
    
    enum SectionModel: SectionModelType {
        case itemSection(title: String, items: [SectionItem])
        
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
    
    enum SectionItem {
        case imageSectionItem(viewModel: ItemImageCell.ViewModel)
    }
}
