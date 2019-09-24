//
//  ConnectionsViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/18/19.
//

import UIKit
import RxDataSources

class ConnectionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ConnectionSection> {
        
        return RxTableViewSectionedReloadDataSource<ConnectionSection>(configureCell: { _, tableView, indexPath, viewModel in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.connectionCell, for: indexPath) else { return UITableViewCell() }
            cell.viewModel = viewModel
            
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNibs()
        
    }
    
    private func prepareNibs() {
        
    }

}
