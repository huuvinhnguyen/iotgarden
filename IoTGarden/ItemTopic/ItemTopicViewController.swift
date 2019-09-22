//
//  ItemTopicViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/22/19.
//

import UIKit
import RxDataSources
import RxSwift

class ItemTopicViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ItemTopicSection> {
        
        return RxTableViewSectionedReloadDataSource<ItemTopicSection>(configureCell: { [weak self] dataSource, tableView, indexPath, _ in
            
            switch dataSource[indexPath] {
            case .headerItem(let viewModel):
                
                return UITableViewCell()

            case .topicItem(let viewModel):

                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicCell, for: indexPath) else { return UITableViewCell() }
                
                //                    cell.viewModel = viewModel
                
                cell.didTapEditAction = {
                    guard let weakSelf = self else { return }
                    let viewController = R.storyboard.connection.serverViewController()!
                    weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                return cell

            case .serverItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemTopicServerCell, for: indexPath) else { return UITableViewCell() }
                
                //                    cell.viewModel = viewModel
                cell.didTapEditAction = {
                    guard let weakSelf = self else { return }
                    let viewController = R.storyboard.connection.serverViewController()!
                    weakSelf.navigationController?.pushViewController(viewController, animated: true)
                    
                }
                return cell

            case .footerItem(let viewModel):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.itemDetailTrashCell, for: indexPath) else { return UITableViewCell() }
                //                cell.viewModel = viewModel
                return cell
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepairNibs()
        loadData()
        
    }
    
    private func loadData() {
        
        let sections: [ItemTopicSection] = [
            
            .topicSection(items: [
                .topicItem(viewModel: ItemTopicViewModel()),
                .topicItem(viewModel: ItemTopicViewModel())
                ]),
            .serverSection(items: [
                .serverItem(viewModel: ItemTopicServerViewModel())
                ]),
            .footerSection(items: [
                .footerItem(viewModel: nil)
                ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.itemTopicCell)
        tableView.register(R.nib.itemTopicServerCell)
        tableView.register(R.nib.itemDetailTrashCell)
    }
    
}
