//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/1/18.
//

import UIKit
import CoreData
import ReSwift
import RxDataSources
import RxSwift
import ReSwiftRouter
import RxCocoa

struct ItemDetailViewModel {
    
    var sensorConnect: SensorConnect? = SensorConnect()
    init(sensor: TopicData) {
        sensorConnect?.connect(sensor: sensor)
    }
}

class ItemDetailViewController: UIViewController, StoreSubscriber {
   
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ItemDetailViewModel?
    private let disposeBag = DisposeBag()
    
    var topicsRelay = PublishRelay<[Topic]>()

    private var dataSource: RxTableViewSectionedReloadDataSource<ItemDetailSectionModel> {
        
        return RxTableViewSectionedReloadDataSource<ItemDetailSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailHeaderCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.didTapEditAction = {
                    guard let self = self else { return }
                    
                    let setDataAction = ReSwiftRouter.SetRouteSpecificData(route: [mainViewRoute, itemDetailRoute, itemNameRoute], data: self.identifier)
                    appStore.dispatch(setDataAction)

                    appStore.dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute, itemDetailRoute, itemNameRoute]))
                
                }
                return cell
                
            case .topicItem(let topic):
                
                if topic?.type == "Switch" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailSwitchCell, for: indexPath) else { return UITableViewCell() }
                    
                    cell.didTapInfoAction = {
                        
                        guard let weakSelf = self else { return }
                        let viewController = R.storyboard.itemTopic.itemTopic()!
                        weakSelf.navigationController?.pushViewController(viewController, animated: true)
                        viewController.identifier = topic?.id
                    }
                    
                    cell.didTapSwitchAction = {
                        if topic?.value == "0" {
                            appStore.dispatch(TopicState.Action.publish(topicId: topic?.id ?? "", message: "1"))
                        } else if topic?.value == "1" {
                            appStore.dispatch(TopicState.Action.publish(topicId: topic?.id ?? "", message: "0"))
                        } else {
                            appStore.dispatch(TopicState.Action.publish(topicId: topic?.id ?? "", message: "0"))
                        }
                        
                    
                        
                    }
                    
                    cell.viewModel = topic
                    return cell
                    
                } else {
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTopicCell, for: indexPath) else { return UITableViewCell() }
                    
//                    cell.viewModel = viewModel
                    return cell
                    
                }
                
                
            case .footerItem(let viewModel):
                if viewModel.kind == "trash" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                    //                cell.viewModel = viewModel
                    cell.didTapTrashAction = {
                        guard let weakSelf = self else { return }

                        let action = ItemState.Action.removeItem(id: weakSelf.identifier)
                        appStore.dispatch(action)
                        weakSelf.navigationController?.popViewController(animated: true)
                        
                    }
                    return cell
                } else if viewModel.kind == "plus" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailPlusCell, for: indexPath) else { return UITableViewCell() }
                    //                cell.viewModel = viewModel
                    cell.didTapPlusAction = {
                        guard let weakSelf = self else { return }
                        let viewController = R.storyboard.connection.topicViewController()!
                        viewController.mode = .add
                        weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    }
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailFooterCell, for: indexPath) else { return UITableViewCell() }
//                cell.viewModel = viewModel
                return cell
            }
        })
    }

    func newState(state: (identifier :String, topicState: TopicState)) {
        
        topicsRelay.accept(state.topicState.topics)
        print("#detail identifier: \(identifier) ")
        self.identifier = state.identifier
        
    }
    
    var sensor: TopicData? {
        didSet {
            viewModel = ItemDetailViewModel(sensor: sensor ?? TopicData())
        }   
    }
    
    var identifier = ""
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            appStore.dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute]))

        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureTableView()

        appStore.subscribe(self) { subcription in
            subcription.select { state in
                let identifier: String = state.navigationState.getRouteSpecificState(
                    state.navigationState.route
                ) ?? ""
                return (identifier, state.topicState)
                
                }
        }    
        appStore.dispatch(TopicState.Action.loadTopics(itemId: ""))
    }
    
    private func configureTableView() {
        
        tableView.register(R.nib.itemDetailHeaderCell)
        tableView.register(R.nib.itemDetailTopicCell)
        tableView.register(R.nib.itemDetailFooterCell)
        tableView.register(R.nib.itemDetailSwitchCell)
        tableView.register(R.nib.itemDetailPlusCell)

        tableView.register(R.nib.itemDetailTrashCell)
        tableView.remembersLastFocusedIndexPath = true

        topicsRelay
            .map { $0.map { ItemDetailSectionItem.topicItem(viewModel: $0)} }
            .map { sectionItems -> [ItemDetailSectionModel] in
                
                var sections: [ItemDetailSectionModel] = []
                let item = appStore.state.itemState.itemViewModels.filter {$0.uuid == self.identifier }.first
                sections.append(
                    .headerSection(items: [.headerItem(viewModel: ItemDetailHeaderCell.ViewModel(name: item?.name ?? ""))])
                )
                
                sections.append(
                    .topicSection(items: sectionItems)
                )
                
                sections.append(
                    .footerSection(items: [
                        .footerItem(viewModel: ItemDetailFooterViewModel(kind: "plus")),
                        .footerItem(viewModel: ItemDetailFooterViewModel(kind: "trash"))
                        ])
                )
                return sections
                
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    

    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let itemListService = ItemListService()
        itemListService.removeTopic(id: sensor?.uuid ?? "")
        let action = ItemState.Action.loadItems()
        appStore.dispatch(action)
        navigationController?.popViewController(animated: true)
    }

}
