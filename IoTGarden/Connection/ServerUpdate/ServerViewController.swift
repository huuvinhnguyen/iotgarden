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
        connectionRelay.accept(state.serverViewModel)
    }
    
    var serverIdentifier: String?
    
    var connectionRelay = PublishRelay<ServerViewModel?>()

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerSection> {
        
        return RxTableViewSectionedReloadDataSource<ServerSection>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            guard let self = self else { return UITableViewCell() }

            
            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
//                cell.viewModel = viewModel
              
                return cell
                
            case .serverItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.serverCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                
                cell.nameTextField.rx.text.subscribe(onNext:{ text in
//                    var topicViewModel = appStore.state.topicState.topicViewModel
//                    topicViewModel?.name = text ?? ""
                }).disposed(by: self.disposeBag)
                
                cell.didTapSelectAction = {

                    let viewController = R.storyboard.selection.selectionViewController()!
                    self.modalPresentationStyle = .currentContext
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
                cell.didTapSaveAction = {
                    
                    var topicViewModel = appStore.state.topicState.topicViewModel
                    if let id = topicViewModel?.connectionId, id != "" {
                        
                        topicViewModel?.connectionId = viewModel?.id ?? ""
                    } else {
                        
                        let connectionViewModel = ConnectionViewModel(id: UUID().uuidString, name: cell.nameTextField.text ?? "", server: cell.serverTextField.text ?? "", title: "", isSelected: true)
                        let action = ConnectionState.Action.addConnection(viewModel: connectionViewModel)
                        topicViewModel?.connectionId = connectionViewModel.id
                        appStore.dispatch(action)
                        
                    }
                    
                    appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: topicViewModel))
                    self.navigationController?.popViewController(animated: true)
                }
                
                cell.didTapTrashAction = {
                    self.navigationController?.popViewController(animated: true)
                    appStore.dispatch(ConnectionState.Action.removeConnection(id: viewModel?.id ?? ""))

                }
                return cell
                
            default:
                return UITableViewCell()
            }
            
            
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
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
    }
    
    private func loadData() {
        
        connectionRelay.map {
            [ServerSection(title: "", items: [.serverItem(viewModel: $0)])]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
}
