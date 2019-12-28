//
//  TopicTypeViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/27/19.
//

import UIKit
import RxSwift
import RxDataSources

class TopicTypeViewController: UIViewController {
    
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
                return UITableViewCell()
                
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
        
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.topicCell)
        tableView.register(R.nib.topicTypeCell)
    }
}
