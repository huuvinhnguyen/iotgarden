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

class ItemNameViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak private var tableView: UITableView!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    func newState(state: ItemState) {
        itemRelay.accept(state.itemImageViewModel)
    }
    
    private let itemRelay = PublishRelay<ItemImageViewModel>()
    private var itemListViewModel = ItemViewModel()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<Section> {
        
        return RxTableViewSectionedReloadDataSource<Section>(configureCell: { dataSource, tableView, indexPath, viewModel in
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemNameHeaderCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                return cell
            case .item(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemNameCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
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
        loadData()
        appStore.subscribe(self) { $0.select { $0.itemState }.skipRepeats() }
        itemRelay.asObservable()
            .subscribe(onNext: { [weak self] viewModel in
                guard let weakSelf = self else { return }
                
                weakSelf.imageButton.sd_setBackgroundImage(with: URL(string: viewModel.imageUrl), for: .normal, completed: nil)
                weakSelf.itemListViewModel.imageUrlString = viewModel.imageUrl

            })
        .disposed(by: disposeBag)
        
//        itemRelay.asObservable()
//            .map { viewModel in
//                [
//                    
//                    Section(title: "", items: [
//                        .headerItem(viewModel: ItemNameHeaderCell.ViewModel(name: viewModel.imageUrl)),
//                        .item(viewModel: ItemNameCell.ViewModel()),
//                        .footerItem()
//                        ])
//                ]
//            }.bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
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

        self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.connection.serverViewController()!
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        itemListViewModel.name = nameTextField.text ?? ""
        self.dismiss(animated: true, completion: nil)
        let action = ItemState.Action.addItem(item: ItemViewModel(uuid: UUID().uuidString, name: itemListViewModel.name, imageUrlString: itemListViewModel.imageUrlString))
        appStore.dispatch(action)
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
