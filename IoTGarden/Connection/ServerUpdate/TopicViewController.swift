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
        topicRelay.accept(state.topic)
        topic = state.topic ?? Topic()
    }
    
    enum Mode {
        case add
        case edit(topicId: String)
        
        var topicId: String {
            switch self {
            case .add: return ""
            case .edit(let id): return id
            }
        }
    }
    
    var mode: Mode?
    
    var identifier: String?
    
    private var topicRelay = PublishRelay<Topic?>()
    private var topic = Topic()
    private var topicViewModel: TopicCell.ViewModel?
    private var switchViewModel: TopicSwitchCell.ViewModel?
    private var qosViewModel: TopicQosCell.ViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<ServerViewController.Section> {
        
        return RxTableViewSectionedReloadDataSource<ServerViewController.Section>(configureCell: { [weak self] dataSource, tableView, indexPath, viewModel in
            
            guard let self = self else { return UITableViewCell() }

            switch dataSource[indexPath] {
                
            case .topicItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicCell, for: indexPath) else { return UITableViewCell() }
                
    
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    
                    self.topicViewModel = viewModel
                    
                }).disposed(by: self.disposeBag)
                

                cell.didTapSelectAction = {
                    let viewController = R.storyboard.selection.selectionViewController()!
                    self.modalPresentationStyle = .currentContext
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
                cell.viewModel = viewModel

                
                return cell
            case .topicSwitchItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSwitchCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    self.switchViewModel = viewModel
                }).disposed(by: self.disposeBag)
                
                return cell
                
            case .topicQosItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicQosCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    self.qosViewModel = viewModel
                }).disposed(by: self.disposeBag)
                
                return cell
            case .topicSaveItem(_):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSaveCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSaveAction = {
                    
//                    self.navigationController?.popViewController(animated: true)
//
//                    if let id = self.identifier {
//                        appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: self.topic))
//                    } else {
//                        self.topic?.id = UUID().uuidString
//                        appStore.dispatch(TopicState.Action.addTopic(viewModel: self.topic))
//                    }
                    
                    self.saveTopic()
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
        
        appStore.dispatch(TopicState.Action.loadTopic(id: mode?.topicId ?? ""))
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
                .topicItem(viewModel: TopicCell.ViewModel(id: $0?.id ?? "", name: $0?.name ?? "" , topic: $0?.topic ?? "", type: $0?.type ?? "")),
                .topicSwitchItem(viewModel: TopicSwitchCell.ViewModel()),
                .topicQosItem(viewModel: TopicQosCell.ViewModel()),
                .topicSaveItem(viewModel: TopicSaveCell.ViewModel())
                
                ])
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func saveTopic() {
        guard let mode = mode else { return }
        
        topic.name = topicViewModel?.name ?? ""
        topic.topic = topicViewModel?.topic ?? ""
        topic.type = topicViewModel?.type ?? ""
        
        
//        topic?.value = switchViewModel?.value ?? ""
        
        
        switch mode {
        case .add:
            topic.id = UUID().uuidString
            appStore.dispatch(TopicState.Action.addTopic(viewModel: self.topic))
        case .edit(_):
            appStore.dispatch(TopicState.Action.updateTopic(topicViewModel: self.topic))
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
