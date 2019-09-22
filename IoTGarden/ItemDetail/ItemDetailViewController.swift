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

struct ItemDetailViewModel {
    
    var sensorConnect: SensorConnect? = SensorConnect()
    init(sensor: Sensor) {
        sensorConnect?.connect(sensor: sensor)
    }
}

class ItemDetailViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel: ItemDetailViewModel?
    private var serverUUID = ""
    private let disposeBag = DisposeBag()

    private var dataSource: RxTableViewSectionedReloadDataSource<ItemDetailSectionModel> {
        
        return RxTableViewSectionedReloadDataSource<ItemDetailSectionModel>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailHeaderCell, for: indexPath) else { return UITableViewCell() }
                
                cell.viewModel = viewModel
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
                    return cell
                } else if viewModel.kind == "plus" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailPlusCell, for: indexPath) else { return UITableViewCell() }
                    //                cell.viewModel = viewModel
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailFooterCell, for: indexPath) else { return UITableViewCell() }
//                cell.viewModel = viewModel
                return cell
            }
        })
    }

    func newState(state: ItemDetailState) {
        
//        nameLabel.text = state.name
//        valueLabel.text = state.value
//        kindLabel.text = state.kind
//        topicLabel.text = state.topic
//        timeLabel.text = state.time
        serverUUID = state.serverUUID
        
//        var timer: Timer?

//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//            guard let weakSelf = self else { return }
//            weakSelf.timeLabel?.text = state.time.toDate()?.timeAgoDisplay()
//        }
    }
    
    
    typealias StoreSubscriberStateType = ItemDetailState
    
    var sensor: Sensor? {
        didSet {
            viewModel = ItemDetailViewModel(sensor: sensor ?? Sensor())
        }
    }
    
    var identifier = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self) { subcription in
            subcription.select { state in state.detailState }.skipRepeats()
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let action = ItemDetailState.Action.loadDetail(id: identifier)
        appStore.dispatch(action)
        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.register(R.nib.itemDetailHeaderCell)
        tableView.register(R.nib.itemDetailTopicCell)
        tableView.register(R.nib.itemDetailFooterCell)
        tableView.register(R.nib.itemDetailSwitchCell)
        tableView.register(R.nib.itemDetailPlusCell)

        tableView.register(R.nib.itemDetailTrashCell)

        let sections: [ItemDetailSectionModel] = [
            .headerSection(items: [.headerItem(viewModel: ItemDetailHeaderViewModel(name: "Header AAA"))]),
            .topicSection(items: [
                .topicItem(viewModel: ItemDetailTopicViewModel(name: "Topic switch", value: "ON", updated: "25-08-2019", type: "Switch")),
                .topicItem(viewModel: ItemDetailTopicViewModel(name: "Topic switch", value: "ON", updated: "25-08-2019", type: "Normal"))
                ]),
            
            .footerSection(items: [
                .footerItem(viewModel: ItemDetailFooterViewModel(kind: "plus")),
                .footerItem(viewModel: ItemDetailFooterViewModel(kind: "trash"))
                ])
        ]

        Observable.just(sections)
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
        itemListService.removeSensor(sensor: sensor ?? Sensor())
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
