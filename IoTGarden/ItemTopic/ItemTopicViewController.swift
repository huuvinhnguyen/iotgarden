//
//  ItemTopicViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import ReSwift

class ItemTopicViewController: UIViewController, StoreSubscriber {
    
    func newState(state: (topicState: TopicState, serverState: ServerState) ){
        topicRelay.accept(state.topicState.topic)
        serverRelay.accept(state.serverState.server)

    }
    var identifier: String?
    var topicRelay = PublishRelay<Topic?>()
    var serverRelay = PublishRelay<Server?>()

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ItemTopicSection> {
        
        return RxTableViewSectionedReloadDataSource<ItemTopicSection>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            guard let self = self else { return UITableViewCell() }
            switch dataSource[indexPath] {
            
            case .topicItem(let viewModel):

                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                
                
                cell.didTapEditAction = {
                    guard let topicId = viewModel?.id else { return }
                    let viewController = R.storyboard.connection.topicViewController()!
                    viewController.mode = .edit(topicId: topicId)
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                return cell


            case .footerItem(_):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapTrashAction = {
                    self.navigationController?.popViewController(animated: true)
                    let action = TopicState.Action.removeTopic(id: self.identifier ?? "")
                    appStore.dispatch(action)
                }
                return cell
            case .footerSignInItem():
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicSignInCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSignInAction = {
                    let viewController = R.storyboard.connection.serverViewController()!
                    guard let topicId = self.identifier else { return }
                    viewController.topicId = topicId
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                return cell
            case .connectionItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicServerCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.didTapEditAction = {
                    let viewController = R.storyboard.connection.serverViewController()!
                    guard let topicId = self.identifier else { return }
                    viewController.topicId = topicId
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                cell.didTapTrashAction = {
                    appStore.dispatch(TopicState.Action.removeServer())
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepairNibs()
        loadData()
        
        appStore.subscribe(self) { subcription in
            subcription.select { state in
            return (state.topicState, state.serverState)
            }
        }
        
        appStore.dispatch(TopicState.Action.loadTopic(id: identifier ?? ""))
    }
    
    private func loadData() {
        
        let tableRelay = Observable.combineLatest(topicRelay, serverRelay).map { topic, server -> [ItemTopicSection] in
            let footerItems = server == nil ? [ItemTopicSectionItem.footerSignInItem(), ItemTopicSectionItem.footerItem(viewModel: nil)] :  [ItemTopicSectionItem.footerItem(viewModel: nil)]
            let serverItems = server == nil ? [] : [ItemTopicSectionItem.connectionItem(viewModel: ItemTopicServerCell.ViewModel(id: server?.id ?? "", name: server?.name ?? "", server: server?.url ?? "", user: server?.user ?? "", password: server?.password ?? "", port: server?.port ?? "", sslPort: server?.sslPort ?? ""))]
            
            let topicViewModel = ItemTopicCell.ViewModel(id: topic?.id ?? "", name: topic?.name ?? "", topic: topic?.topic ?? "", value: topic?.value ?? "", time: topic?.time ?? "11:30", qos: topic?.qos ?? "", retain: topic?.retain ?? "", type: topic?.type ?? "")
            
            return [
                ItemTopicSection.topicSection(items: [
                .topicItem(viewModel: topicViewModel)]),
                .serverSection(items: serverItems),
                .footerSection(items: footerItems)
            ]
        }
        
        tableRelay.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.itemTopicCell)
        tableView.register(R.nib.itemTopicServerCell)
        tableView.register(R.nib.itemDetailTrashCell)
        tableView.register(R.nib.itemTopicSignInCell)
    }
    
}
