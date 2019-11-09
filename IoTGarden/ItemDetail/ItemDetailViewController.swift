//
//  ItemDetailViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 11/1/18.
//

import UIKit
import CoreData
import ReSwift
import RxDataSources
import RxSwift
import RxCocoa

struct ItemDetailViewModel {
    
    var sensorConnect: SensorConnect? = SensorConnect()
    init(sensor: Topic) {
        sensorConnect?.connect(sensor: sensor)
    }
}

class ItemDetailViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ItemDetailViewModel?
    private var serverUUID = ""
    private let disposeBag = DisposeBag()
    
    var sectionItems = PublishRelay<[ItemDetailSectionModel]>()


    private var dataSource: RxTableViewSectionedReloadDataSource<ItemDetailSectionModel> {
        
        return RxTableViewSectionedReloadDataSource<ItemDetailSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailHeaderCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
                cell.didTapEditAction = {
                    guard let weakSelf = self else { return }
                    
                    let viewController = R.storyboard.itemList.instantiateInitialViewController()!
                    weakSelf.modalPresentationStyle = .currentContext
                    weakSelf.present(viewController, animated: true, completion: nil)
                 
                }
                return cell
                
            case .topicItem(let viewModel):
                
                if viewModel.type == "Switch" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailSwitchCell, for: indexPath) else { return UITableViewCell() }
                    
                    cell.didTapInfoAction = {
                        
                        guard let weakSelf = self else { return }
                        let viewController = R.storyboard.itemTopic.itemTopic()!
                        weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    }
                    
//                    cell.viewModel = viewModel
                    return cell
                    
                } else {
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTopicCell, for: indexPath) else { return UITableViewCell() }
                    
                    cell.viewModel = viewModel
                    return cell
                    
                }
                
                return UITableViewCell()
                
            case .footerItem(let viewModel):
                if viewModel.kind == "trash" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                    //                cell.viewModel = viewModel
                    cell.didTapTrashAction = {
                        guard let weakSelf = self else { return }

                        let action = ListState.Action.removeItem(id: weakSelf.identifier)
                        appStore.dispatch(action)
                        weakSelf.navigationController?.popViewController(animated: true)
                        
                    }
                    return cell
                } else if viewModel.kind == "plus" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailPlusCell, for: indexPath) else { return UITableViewCell() }
                    //                cell.viewModel = viewModel
                    cell.didTapPlusAction = {
                        guard let weakSelf = self else { return }
                        let viewController = R.storyboard.connection.topicViewController()!
                        weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    }
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailFooterCell, for: indexPath) else { return UITableViewCell() }
//                cell.viewModel = viewModel
                return cell
            }
        })
    }

    func newState(state: TopicState) {
        
//        serverUUID = state.serverUUID
        sectionItems.accept(state.topicItems)


    }
    
    
    typealias StoreSubscriberStateType = TopicState
    
    var sensor: Topic? {
        didSet {
            viewModel = ItemDetailViewModel(sensor: sensor ?? Topic())
        }   
    }
    
    var identifier = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self) { subcription in
            subcription.select { state in state.topicState }.skipRepeats()
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        appStore.dispatch(TopicState.Action.loadTopics())
        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.register(R.nib.itemDetailHeaderCell)
        tableView.register(R.nib.itemDetailTopicCell)
        tableView.register(R.nib.itemDetailFooterCell)
        tableView.register(R.nib.itemDetailSwitchCell)
        tableView.register(R.nib.itemDetailPlusCell)

        tableView.register(R.nib.itemDetailTrashCell)

    
        sectionItems.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        
        print("Value changed")
    }
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
//        let message = publishTextField.text ?? ""
//        viewModel?.sensorConnect?.publish(message: message)
//        let action = ItemDetailState.Action.publish(message: message, id: identifier)
//        appStore.dispatch(action)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let itemListService = ItemListService()
        itemListService.removeSensor(sensor: sensor ?? Topic())
        let action = ListState.Action.loadItems()
        appStore.dispatch(action)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeMoreDetail(_ sender: UIButton) {
        let vc = R.storyboard.itemDetail.serverViewController()!
        vc.serverUUID = sensor?.serverUUID
        vc.serverUUID = serverUUID
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func editTopicTapped(_ sender: UIButton) {
        let vc = R.storyboard.itemDetail.topicViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
}
