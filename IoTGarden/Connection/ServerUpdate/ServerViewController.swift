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

    func newState(state: ServerState ) {
        serverRelay.accept(state.server)
    }
    
    enum Mode {
        case add(topicId: String, serverId: String)
        case edit(topicId: String, serverId: String)
        var topicId: String {
            switch self {
            case .add(let id, _):
                return id
            case .edit(let id, _):
                return id
            }
        }
        
        var serverId: String {
            switch self {
            case .add(_, let id):
                return id
            case .edit(_, let id):
                return id
            }
        }
    }
    
    private var mode: Mode?
    
    var topicId: String?
    
    private var serverViewModel: ServerCell.ViewModel?
    
    var serverRelay = PublishRelay<Server?>()

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
            
                return cell
                
            case .trashItem(let id):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                
                cell.didTapTrashAction = {
                    self.navigationController?.popViewController(animated: true)
                    appStore.dispatch(ServerState.Action.removeServer(id: id))
                    appStore.dispatch(TopicState.Action.loadTopic(id: self.mode?.topicId ?? ""))

                }
            
                return cell
                
            case .topicSaveItem(_):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSaveCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSaveAction = {
                    self.saveServer()
                }
                return cell
                
            default:
                return UITableViewCell()
            }
        })
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepairNibs()
        guard let id = topicId else { return }
        let topic = appStore.state.topicState.topics.filter { $0.id == id }.first
        if topic?.serverId == "" {
            mode = .add(topicId: topic?.id ?? "", serverId: UUID().uuidString)
        } else {
            mode = .edit(topicId: topic?.id ?? "", serverId: topic?.serverId ?? "")
        }

        
        appStore.subscribe(self) { $0.select { $0.serverState }.skipRepeats() }
        loadData()
        
        appStore.dispatch(ServerState.Action.loadServer(id: mode?.serverId ?? ""))

    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.serverCell)
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.itemDetailTrashCell)
        tableView.register(R.nib.topicSaveCell)

    }
    
    private func saveServer() {
        
        guard let mode = mode else { return }
        guard let viewModel = serverViewModel else { return }
        let server = Server(
            id: mode.serverId, name: viewModel.name,
            url: viewModel.serverUrl,
            user: viewModel.user,
            password: viewModel.password,
            port: viewModel.port,
            sslPort: viewModel.sslPort,
            canDelete: true)

        switch mode {
        case .add(let topicId, _):
            
            var topic = appStore.state.topicState.topics.filter { $0.id == topicId }.first
            topic?.serverId = server.id
            
            appStore.dispatch(ServerState.Action.addServer(server))
            appStore.dispatch(TopicState.Action.updateTopic(topic: topic))
            
        case .edit(_, _):
            
            appStore.dispatch(ServerState.Action.updateServer(server))
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func loadData() {
        
        
        
        
        serverRelay.map { [weak self] in
            var items = [
                SectionItem.serverItem(viewModel: ServerCell.ViewModel(id: $0?.id ?? "", name: $0?.name ?? "", user: $0?.user ?? "", password: $0?.password ?? "", serverUrl: $0?.url ?? "", port: $0?.port ?? "", sslPort: $0?.sslPort ?? "" )),
                SectionItem.topicSaveItem(viewModel: TopicSaveCell.ViewModel())
               ]
            
            if case .edit? = self?.mode {
                items += [SectionItem.trashItem(id: $0?.id ?? "")]
            }

            return [Section(title: "", items: items)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
}
