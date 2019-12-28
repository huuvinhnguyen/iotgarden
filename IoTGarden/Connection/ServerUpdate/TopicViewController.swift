//
//  TopicViewController.swift
//  IoTGarden
//
//  Created by chuyendo on 9/25/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReSwift

class TopicViewController: UIViewController, StoreSubscriber {
    
    func newState(state: TopicState) {
        topicRelay.accept(state.topicViewModel)
        topicViewModel = state.topicViewModel
    }
    
    var identifier: String?
    
    private var topicRelay = PublishRelay<TopicViewModel?>()
    private var topicViewModel: TopicViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerViewController.Section> {
        
        return RxTableViewSectionedReloadDataSource<ServerViewController.Section>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            guard let self = self else { return UITableViewCell() }

            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.nameTextField.rx.text.subscribe(onNext:{ text in
                    self.topicViewModel?.name = text ?? ""
                }).disposed(by: self.disposeBag)
                
                cell.didTapSelectAction = {
                    let viewController = R.storyboard.selection.selectionViewController()!
                    self.modalPresentationStyle = .currentContext
                    self.present(viewController, animated: true, completion: nil)
                    
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
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    if let id = self.identifier {
                        appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: self.topicViewModel))
                    } else {
                        self.topicViewModel?.id = UUID().uuidString
                        appStore.dispatch(TopicState.Action.addTopic(viewModel: self.topicViewModel))
                    }
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
        appStore.subscribe(self) { $0.select { $0.topicState }.skipRepeats() }
        appStore.dispatch(TopicState.Action.loadTopic(id: identifier ?? ""))
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.topicSwitchCell)
        tableView.register(R.nib.topicQosCell)
        tableView.register(R.nib.topicSaveCell)
    }
    
    private func loadData() {
        
        topicRelay.map { [
            ServerViewController.Section(title: "", items: [
                .topicItem(viewModel: TopicCell.ViewModel(name: $0?.name , topic: $0?.topic, type: $0?.type)),
                .topicSwitchItem(viewModel: TopicSwitchViewModel()),
                .topicQosItem(viewModel: TopicQosViewModel()),
                .topicSaveItem(viewModel: TopicSaveCell.ViewModel())
                
                ])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
}
