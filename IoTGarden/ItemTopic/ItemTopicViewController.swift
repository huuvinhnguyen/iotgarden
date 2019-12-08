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
    
    func newState(state: TopicState) {
        topicRelay.accept(state.topicViewModel)
        connectionRelay.accept(state.connectionViewModel)

    }
    var identifier: String?
    var topicRelay = PublishRelay<TopicViewModel?>()
    var connectionRelay = PublishRelay<ConnectionViewModel?>()

    
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
                    let viewController = R.storyboard.connection.topicViewController()!
                    viewController.identifier = viewModel?.id
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                return cell


            case .footerItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                //                cell.viewModel = viewModel
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
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                return cell
            case .connectionItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicServerCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel3 = viewModel
                cell.didTapEditAction = {
                    let viewController = R.storyboard.connection.serverViewController()!
                    viewController.serverIdentifier = viewModel?.id
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                cell.didTapTrashAction = {
                
                    appStore.dispatch(TopicState.Action.removeConnection())
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
        
        appStore.subscribe(self) { $0.select { $0.topicState }.skipRepeats() }
        appStore.dispatch(TopicState.Action.loadTopic2(id: identifier ?? ""))
    }
    
    private func loadData() {
        
        let tableRelay = Observable.combineLatest(topicRelay, connectionRelay).map { topic, connection -> [ItemTopicSection] in
            let footerItems = connection == nil ? [ItemTopicSectionItem.footerSignInItem(), ItemTopicSectionItem.footerItem(viewModel: nil)] :  [ItemTopicSectionItem.footerItem(viewModel: nil)]
            let serverItems = connection == nil ? [] : [ItemTopicSectionItem.connectionItem(viewModel: ItemTopicServerCell.ViewModel(id: connection?.id ?? "", name: connection?.name ?? "", server: "", title: ""))]
            
            return [
                ItemTopicSection.topicSection(items: [
                .topicItem(viewModel: topic)]),
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
