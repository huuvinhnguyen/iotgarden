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
    
    var connectionRelay = PublishRelay<ServerViewModel?>()

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerSection> {
        
        return RxTableViewSectionedReloadDataSource<ServerSection>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
//                cell.viewModel = viewModel
              
                return cell
                
            case .serverItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.serverCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                cell.didTapSelectAction = {

                    let viewController = R.storyboard.selection.selectionViewController()!
                    guard let weakSelf = self else { return }
                    weakSelf.modalPresentationStyle = .currentContext
                    weakSelf.present(viewController, animated: true, completion: nil)
                    
                }
                
                cell.didTapSaveAction = {
                    guard let weakSelf = self else { return }
                    let action = ConnectionState.Action.addConnection(viewModel: ConnectionViewModel(id: UUID().uuidString, name: cell.nameTextField.text ?? "", server: cell.serverTextField.text ?? "", title: "", isSelected: true))
                    appStore.dispatch(action)
                    
                    weakSelf.navigationController?.popViewController(animated: true)
                }
                
                cell.didTapTrashAction = {
                    guard let weakSelf = self else { return }
                    weakSelf.navigationController?.popViewController(animated: true)
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
        
        appStore.dispatch(ConnectionState.Action.loadConnection(id: ""))

    
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.serverCell)
        tableView.register(R.nib.topicCell)
    }
    
    private func loadData() {
        
        connectionRelay.map {
            [ServerSection(title: "", items: [.serverItem(viewModel: $0)])]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
}
