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
        topicRelay.accept(state.editableTopic)
        topic = state.editableTopic ?? Topic()
    }
    
    enum Mode {
        case add(itemId: String)
        case edit(topicId: String)
        
        var topicId: String {
            switch self {
            case .add: return ""
            case .edit(let id): return id
            }
        }
    }
    
    var mode: Mode = .add(itemId: "")
    
    var identifier: String?
    
    private var topicRelay = PublishRelay<Topic?>()
    private var topic = Topic()
    private var topicViewModel: TopicCell.ViewModel?
    private var switchViewModel: TopicSwitchCell.ViewModel?
    private var qosViewModel: TopicQosCell.ViewModel?
    private var retainViewModel: TopicRetainCell.ViewModel?
    
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
                    let viewController = R.storyboard.connection.topicTypeViewController()!
                    self.modalPresentationStyle = .currentContext
                    self.present(viewController, animated: true, completion: nil)
                    viewController.topic = self.topic
                }
                
                cell.configure(viewModel: viewModel)

                return cell
            case .topicSwitchItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSwitchCell, for: indexPath) else { return UITableViewCell() }
                
                    cell.viewModelRelay.subscribe(onNext: { viewModel in
                    self.switchViewModel = viewModel
                }).disposed(by: self.disposeBag)
                cell.viewModel = viewModel

                return cell
                
            case .topicQosItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicQosCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    self.qosViewModel = viewModel
                }).disposed(by: self.disposeBag)
                
                return cell
            case .topicRetainItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicRetainCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                cell.viewModelRelay.subscribe(onNext: { viewModel in
                    self.retainViewModel = viewModel
                }).disposed(by: self.disposeBag)
                
                return cell
        
            case .topicSaveItem(_):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicSaveCell, for: indexPath) else { return UITableViewCell() }
                cell.didTapSaveAction = {
                    
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
        
        if case .add = mode {
            var topic = Topic()
            topic.type = "switch"
            topic.qos = "2"
            topic.retain = "1"
            appStore.dispatch(TopicState.Action.fetchEditableTopic(topic: topic))
        } else {
            let topic = appStore.state.topicState.topic
            appStore.dispatch(TopicState.Action.fetchEditableTopic(topic: topic))
        }        
     }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.topicSwitchCell)
        tableView.register(R.nib.topicQosCell)
        tableView.register(R.nib.topicRetainCell)
        tableView.register(R.nib.topicSaveCell)
    }
    
    private func loadData() {
        
        topicRelay.map { [weak self] item in
            let item = item ?? Topic()
            var items: [ServerViewController.SectionItem] = []
            items += [ServerViewController.SectionItem.topicItem(viewModel: TopicCell.ViewModel(id: item.id, name: item.name, topic: item.topic, type: item.type))]
            
            if item.type == "switch" {
                items += [ServerViewController.SectionItem.topicSwitchItem(viewModel: TopicSwitchCell.ViewModel(value: item.value, message: item.message))]
            }
            let qos = self?.qosViewModel?.value
            items += [ServerViewController.SectionItem.topicQosItem(viewModel: TopicQosCell.ViewModel(value: qos ?? item.qos))]
            
            let retain = self?.retainViewModel?.value
            items += [ServerViewController.SectionItem.topicRetainItem(viewModel: TopicRetainCell.ViewModel(value: retain ?? item.retain)),
                      ServerViewController.SectionItem.topicSaveItem(viewModel: TopicSaveCell.ViewModel())]
            
            
            return [
            ServerViewController.Section(title: "", items: items
                )]
            
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func saveTopic() {
        
        topic.name = topicViewModel?.name ?? ""
        topic.topic = topicViewModel?.topic ?? ""
        topic.type = topicViewModel?.type ?? ""
        topic.message = switchViewModel?.message ?? ""
        topic.qos = qosViewModel?.value ?? ""
        topic.retain = retainViewModel?.value ?? ""
        
        switch mode {
        case .add(let itemId):
            topic.id = UUID().uuidString
            topic.itemId = itemId
            appStore.dispatch(TopicState.Action.addTopic(topic: self.topic))
        case .edit(_):
            appStore.dispatch(TopicState.Action.updateTopic(topic: self.topic))
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
