//
//  ItemNameViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/26/19.
//

import UIKit
import ReSwift
import RxCocoa
import RxSwift
import SDWebImage
import RxDataSources
import ReSwiftRouter

class ItemNameViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak private var tableView: UITableView!
    private let disposeBag = DisposeBag()

    func newState(state: (identifier :String, itemState: ItemState)) {
        itemRelay.accept(state.itemState.itemViewModel)
        self.identifier = state.identifier
        print("#item name identifier: \(identifier)")

    }
    
    var identifier = ""
    
    private let itemRelay = PublishRelay<ItemViewModel>()
    private var itemViewModel = ItemViewModel()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<Section> {
        
        return RxTableViewSectionedReloadDataSource<Section>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            guard let self = self else { return UITableViewCell() }
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemNameHeaderCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                cell.nameTextField.rx.text.subscribe(onNext:{ text in
                    self.itemViewModel.name = text ?? ""
                }).disposed(by: self.disposeBag)
                return cell
            case .item(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemNameCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                self.itemViewModel.imageUrl = viewModel?.imageUrl ?? ""
                cell.didTapSelectAction = {
                    let vc = R.storyboard.itemList.itemImageViewController()!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            case .footerItem():
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemSaveCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSaveAction = {
                    self.saveButtonTapped("")
                }
                
                return cell
            }
        })
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNibs()

        appStore.subscribe(self) { subcription in
            subcription.select { state in
                let identifier: String = state.navigationState.getRouteSpecificState(
                    state.navigationState.route
                    ) ?? ""
                return (identifier, state.itemState)
                
            }
        }
        
        itemRelay.map { viewModel in
            [
                
                                    Section(title: "", items: [
                                        .headerItem(viewModel: ItemNameHeaderCell.ViewModel(name: viewModel.name)),
                                        .item(viewModel: ItemNameCell.ViewModel(imageUrl: viewModel.imageUrl)),
                                        .footerItem()
                                        ])
                                ]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        
        appStore.dispatch(ItemState.Action.loadItem(id: identifier))
        
    }
    
    private func prepareNibs() {
        tableView.register(R.nib.itemNameCell)
        tableView.register(R.nib.itemNameHeaderCell)
        tableView.register(R.nib.itemSaveCell)
    }
    
    private func loadData() {
        
                let sections: [Section] = [
        
                    Section(title: "", items: [
                        .headerItem(viewModel: ItemNameHeaderCell.ViewModel(name: "abc")),
                        .item(viewModel: ItemNameCell.ViewModel()),
                        .footerItem()
                        ])
                ]
        
                Observable.just(sections)
                    .bind(to: tableView.rx.items(dataSource: dataSource))
                    .disposed(by: disposeBag)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        let routes =  identifier == "" ? [mainViewRoute] : [mainViewRoute, itemDetailRoute]
        appStore.dispatch(ReSwiftRouter.SetRouteAction(routes))
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.connection.serverViewController()!
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let id = self.identifier == "" ?  UUID().uuidString : self.identifier
        
        if self.identifier == "" {
            let action = ItemState.Action.addItem(item: ItemViewModel(uuid: id, name: itemViewModel.name, imageUrl: itemViewModel.imageUrl))
            appStore.dispatch(action)
        } else {
            let action = ItemState.Action.updateItem(item: ItemViewModel(uuid: id, name: itemViewModel.name, imageUrl: itemViewModel.imageUrl))
            appStore.dispatch(action)
        }
        
        let routes = [mainViewRoute, itemDetailRoute]
        let setDataAction = ReSwiftRouter.SetRouteSpecificData(route: routes, data: id )
        appStore.dispatch(setDataAction)
        appStore.dispatch(ReSwiftRouter.SetRouteAction(routes))

    }
    
    @IBAction func pictureButtonTapped(_ sender: Any) {
        let vc = R.storyboard.itemList.itemImageViewController()!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ItemNameViewController {
    
    struct Section: SectionModelType {
        
        var title: String
        var items: [Item]
        typealias Item = SectionItem
        
        init(title: String, items: [Item]) {
            self.title = title
            self.items = items
        }

        init(original: Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
    
    enum SectionItem {
        case headerItem(viewModel: ItemNameHeaderCell.ViewModel?)
        case item(viewModel: ItemNameCell.ViewModel?)
        case footerItem()
    }
}
