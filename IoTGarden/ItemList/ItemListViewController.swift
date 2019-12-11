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
    
    func newState(state: ItemState) {
        itemRelay.accept(state.itemViewModels)
    }
    
    var itemRelay = PublishRelay<[ItemViewModel]>()


    typealias StoreSubscriberStateType = ItemState
    
    @IBOutlet weak var itemListCollectionView: UICollectionView!
    private let itemListService = ItemListService()
    
    
    private let refreshControl = UIRefreshControl()

    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self) { $0.select { $0.listState }.skipRepeats() }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()

        let action = ItemState.Action.loadItems()
        appStore.dispatch(action)
        
        itemRelay.asObservable()
            .map { item -> [SectionItem] in
                
                let items: [SectionItem] = item.map { SectionItem.itemListSectionItem(viewModel: ItemListCell.ViewModel(uuid: $0.uuid, name: $0.name, imageUrl: $0.imageUrlString))}
                let tailItem = SectionItem.tailSectionItem()
                
                var sectionItems: [SectionItem] = []
                sectionItems.append(tailItem)
                sectionItems += items
                return sectionItems
            }.map {[AnimatableSectionModel<String, SectionItem>(model: "", items: $0)]}
            .bind(to: itemListCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        itemListCollectionView.rx.modelSelected(SectionItem.self).subscribe(onNext:{ [weak self] sectionItem in
            guard let weakSelf = self else { return }
            
            if case  SectionItem.tailSectionItem() = sectionItem {
                
                let viewController = R.storyboard.itemList.instantiateInitialViewController()!
                weakSelf.modalPresentationStyle = .currentContext
                weakSelf.present(viewController, animated: true, completion: nil)
                
                
            } else {
                
                let vc = R.storyboard.itemDetail.itemDetailViewController()!
                weakSelf.navigationController?.pushViewController(vc, animated: true)
                
                vc.identifier = sectionItem.identity
                
            }
            
            
        }).disposed(by: disposeBag)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        let screenWidth = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        itemListCollectionView.collectionViewLayout = layout


    }
    
    private func prepareNibs() {
        
        
        itemListCollectionView.register(UINib(nibName: "ItemListCell", bundle: nil), forCellWithReuseIdentifier: "ItemListCell")

        itemListCollectionView.register(UINib(nibName: "TemperatureCell", bundle: nil), forCellWithReuseIdentifier: "TemperatureCell")
        
        itemListCollectionView.register(UINib(nibName: "HumidityCell", bundle: nil), forCellWithReuseIdentifier: "HumidityCell")
        
        itemListCollectionView.register(UINib(nibName: "MotionCell", bundle: nil), forCellWithReuseIdentifier: "MotionCell")
        
        itemListCollectionView.register(UINib(nibName: "ItemInputValueCell", bundle: nil), forCellWithReuseIdentifier: "ItemInputValueCell")
        
        itemListCollectionView.register(UINib(nibName: "ItemListPlusCell", bundle: nil), forCellWithReuseIdentifier: "ItemListPlusCell")
    }
    
    private func configureRefreshControl() {
        
        let action = ItemState.Action.loadItems()
        appStore.dispatch(action)
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        let addItemViewController = R.storyboard.addItemViewController.addItemViewController()!
        navigationController?.pushViewController(addItemViewController, animated: true)
    }

}

enum ItemSectionModel {
    case itemSection(title: String, items: [SectionItem])
}

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
    case headerSectionItem()
    case itemListSectionItem(viewModel: ItemListCell.ViewModel?)
    case switchSectionItem(cellUI: SwitchCellUI)
    case inputSectionItem(cellUI: InputCellUI)
    case temperatureSectionItem(name: TemperatureDevice)
    case tailSectionItem()
}


extension SectionItem: IdentifiableType, Equatable {
    
    
    static func == (lhs: SectionItem, rhs: SectionItem) -> Bool {

        print("left message: \(lhs.message)")
        print("right message: \(rhs.message)")
        return lhs.message == rhs.message
    }
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .itemListSectionItem(let viewModel):
            return viewModel?.uuid ?? ""
        case .switchSectionItem(let viewModel):
            return viewModel.uuid
        case .inputSectionItem(let viewModel):
            return viewModel.uuid
        default:
            return ""
        }
    }
    
    var message: String {
        switch self {
            
        case .switchSectionItem(let viewModel):
            return viewModel.message

        case .inputSectionItem(let viewModel):
            return viewModel.message
        default:
            return ""
        }
    }
}

extension ItemListViewController {
    
    func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, SectionItem>>{
        
        return RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, SectionItem>>(configureCell: { dataSource, collectionView, indexPath, _ in
            
            print("rendering cells")

            switch dataSource[indexPath] {
            case let .itemListSectionItem(viewModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
                //                cell.configure(cellUI: cellUI)
                cell.viewModel2 = viewModel
                return cell
                
            case let .switchSectionItem(cellUI):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
//                cell.configure(cellUI: cellUI)
                return cell
                
            case let .inputSectionItem(cellUI):
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemInputValueCell", for: indexPath) as! ItemInputValueCell
                cell.configure(cellUI: cellUI)
                return cell
                
            case .tailSectionItem():
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListPlusCell", for: indexPath) as! ItemListPlusCell
                return cell
            default:
                return UICollectionViewCell()
            }
        })
    }
}
