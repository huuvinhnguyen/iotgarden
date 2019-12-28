//
//  ServerViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReSwift

class ServerViewController: UIViewController, StoreSubscriber {

    func newState(state: ConnectionState) {
        connectionRelay.accept(state.server)
    }
    
    enum Mode {
        case add(topicId: String)
        case edit(topicId: String)
        var topicId: String {
            switch self {
            case .add(let topicId):
                return topicId
            case .edit(let topicId):
                return topicId
            }
        }
    }
    
    var mode: Mode?
    
    
    var serverIdentifier: String?
    
    var serverViewModel: ServerCell.ViewModel?
    
    var connectionRelay = PublishRelay<Server?>()

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<Section> {
        
        return RxTableViewSectionedReloadDataSource<Section>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            guard let self = self else { return UITableViewCell() }

            
            switch dataSource[indexPath] {
                
            case .serverItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.serverCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    
                    self.serverViewModel = viewModel
                    
                }).disposed(by: self.disposeBag)
                
                cell.didTapSelectAction = {

                    let viewController = R.storyboard.selection.selectionViewController()!
                    self.modalPresentationStyle = .currentContext
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
                
                cell.didTapSaveAction = { _ in
                    
                    self.saveServer()
                    
                }
            
                return cell
                
            case .trashItem(let id):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                
                cell.didTapTrashAction = {
                    self.navigationController?.popViewController(animated: true)
                    appStore.dispatch(ConnectionState.Action.removeConnection(id: id))
                    appStore.dispatch(TopicState.Action.loadTopic(id: self.mode?.topicId ?? ""))

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
        
        appStore.subscribe(self) { $0.select { $0.connectionState }.skipRepeats() }
        loadData()
        
        appStore.dispatch(ConnectionState.Action.loadConnection(id: serverIdentifier ?? ""))

    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.serverCell)
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.itemDetailTrashCell)
    }
    
    private func saveServer() {
        
        guard let mode = mode else { return }
        switch mode {
        case .add(let topicId):
            var topic = appStore.state.topicState.topicViewModels.filter { $0.id == topicId}.first
            let serverId = serverIdentifier ?? UUID().uuidString
            let server = Server(
                id: serverId, name: serverViewModel?.name ?? "",
                url: serverViewModel?.serverUrl ?? "",
                user: serverViewModel?.user ?? "",
                password: serverViewModel?.password ?? "",
                port: serverViewModel?.port ?? "",
                sslPort: serverViewModel?.sslPort ?? "")
            
            topic?.serverId = server.id
            
            appStore.dispatch(ConnectionState.Action.addServer(server))
            appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: topic))
            
        case .edit(let topicId):
            var topic = appStore.state.topicState.topicViewModels.filter { $0.id == topicId}.first
            guard let serverId = serverIdentifier else { return }
            let server = Server(
                id: serverId, name: serverViewModel?.name ?? "",
                url: serverViewModel?.serverUrl ?? "",
                user: serverViewModel?.user ?? "",
                password: serverViewModel?.password ?? "",
                port: serverViewModel?.port ?? "",
                sslPort: serverViewModel?.sslPort ?? "")
            
            topic?.serverId = server.id
            
            appStore.dispatch(ConnectionState.Action.updateServer(server))
            appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: topic))
            
            
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func loadData() {
        
        connectionRelay.map {
            [Section(title: "", items: [
                SectionItem.serverItem(viewModel: ServerCell.ViewModel(id: $0?.id ?? "", name: $0?.name ?? "", user: $0?.user ?? "", password: $0?.password ?? "", serverUrl: $0?.url ?? "", port: $0?.port ?? "", sslPort: $0?.sslPort ?? "" )),
                SectionItem.trashItem(id: $0?.id ?? "")
                                              ])]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
}
