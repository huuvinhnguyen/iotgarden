//
//  ServerViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit
import RxSwift
import RxDataSources

class ServerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerSection> {
        
        return RxTableViewSectionedReloadDataSource<ServerSection>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
                //            cell.viewModel = viewModel
              
                return cell
                
            case .serverItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.serverCell, for: indexPath) else { return UITableViewCell() }
                //            cell.viewModel = viewModel
                cell.didTapSelectAction = {

                    let viewController = R.storyboard.selection.selectionViewController()!
                    guard let weakSelf = self else { return }
                    weakSelf.modalPresentationStyle = .currentContext
                    weakSelf.present(viewController, animated: true, completion: nil)
                    
                }
                
                cell.didTapSaveAction = {
                    guard let weakSelf = self else { return }
                    let action = ConnectionState.Action.addConnection(viewModel: ConnectionViewModel(id: UUID().uuidString, name: "Name 1", server: "ABCD server", title: "", isSelected: true))
                    appStore.dispatch(action)
                    
                    weakSelf.navigationController?.popViewController(animated: true)
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
        loadData()
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.serverCell)
        tableView.register(R.nib.topicCell)
    }
    
    private func loadData() {
        
        let sections: [ServerSection] = [
        
            ServerSection(title: "", items: [.serverItem(viewModel: ServerViewModel(id: "", name: "server abc", url: "http://"))
                ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}
