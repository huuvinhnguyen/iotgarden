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
        connectionRelay.accept(state.serverViewModel)
    }
    var identifier: String?
    var topicRelay = PublishRelay<TopicViewModel?>()
    var connectionRelay = PublishRelay<ServerViewModel?>()
    
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ItemTopicSection> {
        
        return RxTableViewSectionedReloadDataSource<ItemTopicSection>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            guard let self = self else { return UITableViewCell() }
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                
                return UITableViewCell()

            case .topicItem(let viewModel):

                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                
                cell.didTapEditAction = {
                    let viewController = R.storyboard.connection.topicViewController()!
                    viewController.identifier = viewModel?.id
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                return cell

            case .serverItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicServerCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.didTapEditAction = {
                    let viewController = R.storyboard.connection.serverViewController()!
                viewController.serverIdentifier = viewModel?.id
                self.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                cell.didTapTrashAction = {


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
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepairNibs()
        loadData()
        
        appStore.subscribe(self) { $0.select { $0.topicState }.skipRepeats() }
        appStore.dispatch(TopicState.Action.loadTopic(id: identifier ?? ""))
    }
    
    private func loadData() {
        
        let tableRelay = Observable.combineLatest( topicRelay, connectionRelay).map { topic, connection in
            [
                ItemTopicSection.topicSection(items: [
                .topicItem(viewModel: topic)]),
                .serverSection(items: [
                    .serverItem(viewModel: connection)
                    ]),
                .footerSection(items: [
                    .footerItem(viewModel: nil)
                    ])
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
    }
    
}
