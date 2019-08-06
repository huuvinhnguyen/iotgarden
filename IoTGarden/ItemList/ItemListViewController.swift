//
//  ItemListViewController.swift
//  IoTGarden
//
//  Created by Apple on 10/31/18.
//

import UIKit
import ReactiveReSwift
import MaterialComponents.MaterialNavigationBar
import RxDataSources
import RxSwift
import RxCocoa
import ReSwift

private struct ItemDef {
    let title: String
    let subtitle: String
    let `class`: AnyClass
}

class ItemListViewController: UIViewController, StoreSubscriber {
    
    func newState(state: ListState) {
       
        listSection.accept(state.sections)

    }

    var listSection = PublishRelay<[ItemSectionModel]>()

    typealias StoreSubscriberStateType = ListState
    
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    private let itemListService = ItemListService()
    private var cellViewModels: [CellViewModel] = []
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = SubscriptionReferenceBag()
    let disposeBag2 = DisposeBag()
    
    
    override func viewWillAppear(_ animated: Bool) {
        appStore.subscribe(self) { subcription in
            subcription.select {
                state in state.listState
            }.skipRepeats()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()


        let action = ListState.Action.loadItems()
        appStore.dispatch(action)
    
        listSection.asObservable()
            .bind(to: itemListCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag2)
        
        
        itemListCollectionView.rx.setDelegate(self).disposed(by: disposeBag2)
        
        itemListCollectionView.rx.itemSelected.subscribe(onNext:{ indexPath in
            
        }).disposed(by: disposeBag2)
        
        itemListCollectionView.rx.modelSelected(SectionItem.self).subscribe(onNext:{ [weak self] sectionItem in
            guard let weakSelf = self else { return }
            let vc = R.storyboard.itemDetail.itemDetailViewController()!
            weakSelf.navigationController?.pushViewController(vc, animated: true)
            
            vc.sensor = sectionItem.cellViewModel.sensor
        }).disposed(by: disposeBag2)


    }
    
    private func prepareNibs() {
        
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")

        itemListCollectionView.register(UINib(nibName: "TemperatureCell", bundle: nil), forCellWithReuseIdentifier: "TemperatureCell")
        
        itemListCollectionView.register(UINib(nibName: "HumidityCell", bundle: nil), forCellWithReuseIdentifier: "HumidityCell")
        
        itemListCollectionView.register(UINib(nibName: "MotionCell", bundle: nil), forCellWithReuseIdentifier: "MotionCell")
        
        itemListCollectionView.register(UINib(nibName: "ItemInputValueCell", bundle: nil), forCellWithReuseIdentifier: "ItemInputValueCell")
    }
    
    private func configureRefreshControl() {
        
        let action = ListState.Action.loadItems()
        appStore.dispatch(action)
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        let addItemViewController = R.storyboard.addItemViewController.addItemViewController()!
        navigationController?.pushViewController(addItemViewController, animated: true)
    }
    
    @IBAction func tempButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ItemDetailTempViewController", bundle: nil)
        if let itemDetailTempViewController = storyboard.instantiateViewController(withIdentifier :"ItemDetailTempViewController") as? ItemDetailTempViewController {
            
            navigationController?.pushViewController(itemDetailTempViewController, animated: true)
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    

}

enum ItemSectionModel {
    case itemSection(title: String, items: [SectionItem])
}

//extension ItemSectionModel: IdentifiableType {
//    var identity: String {
//        return ""
//        
//    }
//    
//    typealias Identity = String
//}


extension ItemSectionModel: SectionModelType {
    typealias Item = SectionItem
    init(original: ItemSectionModel, items: [Item]) {
        switch original {
        case let .itemSection(title: title, items: items):
             self = .itemSection(title: title, items: items)
        }
    }
    
    var items: [SectionItem] {
        switch self {
        case .itemSection(title: _, items: let items):
            return items.map {$0}
        }
    }
}

enum SectionItem {
    case switchSectionItem(viewModel: SwitchCellViewModel)
    case valueSectionItem(viewModel: InputDevice)
    case temperatureSectionItem(name: TemperatureDevice)
}

extension SectionItem {
    var cellViewModel: CellViewModel {
        switch self {
        case .switchSectionItem(let viewModel):
            return viewModel
        case .valueSectionItem(let viewModel):
            return viewModel
        case .temperatureSectionItem( let viewModel):
            return viewModel
        }
    }
}

extension ItemListViewController {
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<ItemSectionModel> {
        
        return RxCollectionViewSectionedReloadDataSource<ItemSectionModel>(configureCell: { dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
                
            case let .switchSectionItem(switchCellViewModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
                cell.display(cellViewModel: switchCellViewModel)
                return cell
                
            case let .valueSectionItem(viewModel):
                let cell = CellCreator.create(cellAt: indexPath, with: viewModel, collectionView: collectionView)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        })
    }
}
