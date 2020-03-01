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

class ItemDetailViewController: UIViewController, StoreSubscriber {
   
    
    @IBOutlet weak private var tableView: UITableView!

    private let disposeBag = DisposeBag()
    
    lazy var heightDictionary: [Int: CGFloat] = [:]
    
    var topicsRelay = PublishRelay<[Topic]>()

    private var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, SectionItem>> {
        
        return RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, SectionItem>>(animationConfiguration: AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none),configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            
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
            case .topicValueItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTopicCell, for: indexPath) else { return UITableViewCell() }
                
                cell.didTapInfoAction = {
                    
                    guard let weakSelf = self else { return }
                    let viewController = R.storyboard.itemTopic.itemTopic()!
                    weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    viewController.identifier = viewModel.id
                }
                
                cell.didTapPublishAction = { messageResult in
                    appStore.dispatch(TopicState.Action.publish(topicId: viewModel.id, message: messageResult))
                }
                
                cell.viewModel = viewModel
                return cell
                
            case .topicSwitchItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailSwitchCell, for: indexPath) else { return UITableViewCell() }
                
                cell.didTapInfoAction = {
                    
                    guard let weakSelf = self else { return }
                    let viewController = R.storyboard.itemTopic.itemTopic()!
                    weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    viewController.identifier = viewModel.id
                }
                
                cell.didTapSwitchAction = { messageResult in
                    
                    appStore.dispatch(TopicState.Action.publish(topicId: viewModel.id, message: messageResult))
                    
                }
                cell.viewModel = viewModel
                return cell
            case .plusItem:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailPlusCell, for: indexPath) else { return UITableViewCell() }
                
                cell.didTapPlusAction = {
                    guard let weakSelf = self else { return }
                    let viewController = R.storyboard.connection.topicViewController()!
                    viewController.mode = .add(itemId: self?.identifier ?? "")
                    weakSelf.navigationController?.pushViewController(viewController, animated: true)
                }
                return cell
            case .trashItem:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapTrashAction = {
                    guard let weakSelf = self else { return }
                    
                    let action = ItemState.Action.removeItem(id: weakSelf.identifier)
                    appStore.dispatch(action)
                    weakSelf.navigationController?.popViewController(animated: true)
                    
                }
                return cell
                
            default: return UITableViewCell()

            }
            
        })
    }

    func newState(state: (identifier :String, topicState: TopicState)) {
        self.identifier = state.identifier
        if identifier == "" { return }
        topicsRelay.accept(state.topicState.topics)
        print("#detail identifier: \(identifier) ")
        
    }
    
    
    var identifier = ""
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            appStore.dispatch(ReSwiftRouter.SetRouteAction([mainViewRoute]))
            appStore.dispatch(TopicState.Action.stopAllTasks)
            appStore.dispatch(TopicState.Action.clearAllTopics)

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
     
        appStore.dispatch(TopicState.Action.loadTopics(itemId: identifier))
    }
    
    private func configureTableView() {
        
        tableView.register(R.nib.itemDetailHeaderCell)
        tableView.register(R.nib.itemDetailTopicCell)
        tableView.register(R.nib.itemDetailFooterCell)
        tableView.register(R.nib.itemDetailSwitchCell)
        tableView.register(R.nib.itemDetailPlusCell)

        tableView.register(R.nib.itemDetailTrashCell)
        tableView.remembersLastFocusedIndexPath = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self

        
        

        topicsRelay.distinctUntilChanged()
            .map { $0.map { topic -> SectionItem in
                
                if topic.type == "switch" {
                    return SectionItem.topicSwitchItem(viewModel:  ItemDetailSwitchCell.ViewModel(id: topic.id, name: topic.name, value: topic.value, message: topic.message, time: topic.time))
                }
                
                if topic.type == "value" {
                    return SectionItem.topicValueItem(viewModel:  ItemDetailTopicCell.ViewModel(id: topic.id, name: topic.name, value: topic.value, message: topic.message, time: topic.time
                    ))
                }
                return SectionItem.topicItem
                
                }
                
            }
            .map { sectionItems -> [AnimatableSectionModel<String, SectionItem>] in
            
                var sections: [Section] = []
                let item = appStore.state.itemState.items.filter {$0.uuid == self.identifier }.first

                var list = [SectionItem]()

                list += [SectionItem.headerItem(viewModel: ItemDetailHeaderCell.ViewModel(name: item?.name ?? ""))]
                
                sections.append(
                    .topicSection(items: sectionItems)
                )
                list += sectionItems
                list += [SectionItem.plusItem, SectionItem.trashItem]
                
                return [AnimatableSectionModel<String, SectionItem>(model: "", items: list)]
                
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}

extension ItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
}
