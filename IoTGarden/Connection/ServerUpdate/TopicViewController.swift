//
//  TopicViewController.swift
//  IoTGarden
//
//  Created by chuyendo on 9/25/19.
//

import UIKit
import RxSwift
import RxDataSources
import ReSwift

class TopicViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = TopicState

    
    func newState(state: TopicState) {
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerSection> {
        
        return RxTableViewSectionedReloadDataSource<ServerSection>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
                //            cell.viewModel = viewModel
                cell.didTapSelectAction = {
                    let viewController = R.storyboard.selection.selectionViewController()!
                    guard let weakSelf = self else { return }
                    weakSelf.modalPresentationStyle = .currentContext
                    weakSelf.present(viewController, animated: true, completion: nil)
                    
                }
                
                return cell
            case .topicSwitchItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSwitchCell, for: indexPath) else { return UITableViewCell() }
                return cell
                
            case .topicQosItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicQosCell, for: indexPath) else { return UITableViewCell() }
                return cell
            case .topicSaveItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSaveCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSaveAction = {
                    guard let weakSelf = self else { return }
                    weakSelf.navigationController?.popViewController(animated: true)
                    appStore.dispatch(TopicState.Action.addTopic())
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
        
//        tableView.register(R.nib.serverCell)
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.topicSwitchCell)
        tableView.register(R.nib.topicQosCell)
        tableView.register(R.nib.topicSaveCell)
    }
    
    private func loadData() {
        
        let sections: [ServerSection] = [

            ServerSection(title: "", items: [
                .topicItem(viewModel: TopicViewModel()),
                .topicSwitchItem(viewModel: TopicSwitchViewModel()),
                .topicQosItem(viewModel: TopicQosViewModel()),
                .topicSaveItem(viewModel: TopicSaveViewModel())

                ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}
