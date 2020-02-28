//
//  SelectionViewController.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import ReSwift

class SelectionViewController:  UIViewController, StoreSubscriber {
    
    
    func newState(state: ServerState) {
        
        serversRelay.accept(state.servers)
        
    }
    
    var serversRelay = PublishRelay<[Server]>()
    var selectedRelay = PublishRelay<String>()
    var selectedId = ""

    
    private var disposeBag = DisposeBag()
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        appStore.dispatch(ServerState.Action.loadServer(id: selectedId))

        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SelectionSection> {
        
        return RxTableViewSectionedReloadDataSource<SelectionSection>(configureCell: { dataSource, tableView, indexPath, viewModel in
            
            switch dataSource[indexPath] {
            case let .serverItem(viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectionServerCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                return cell
            default: return UITableViewCell()
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        loadData()

        
        appStore.subscribe(self) { subcription in
            subcription.select { state in state.serverState }.skipRepeats()
        }
        
        appStore.dispatch(ServerState.Action.loadServers())
        selectedRelay.accept(selectedId)

    }
    
    private func prepareNibs() {
        
        tableView.register(R.nib.selectionServerCell)
    }
    
    private func loadData() {
        
        Observable.combineLatest( serversRelay, selectedRelay).map { servers, id in
            servers.map { item -> SelectionSectionItem in
                SelectionSectionItem.serverItem(viewModel: SelectionServerCell.ViewModel(id: item.id, name:item.name, server: item.url, isSelected: item.id == id))
            }}
            .map {  sectionItems -> [SelectionSection] in
                var sections: [SelectionSection] = []
                sections.append(
                    SelectionSection(title: "", items: sectionItems)
                )
                return sections
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SelectionSectionItem.self).subscribe(onNext: { [weak self]  sectionItem in
            
            if case  SelectionSectionItem.serverItem(let viewModel) = sectionItem {
                guard let self = self else { return }
                self.selectedRelay.accept(viewModel.id)
                self.selectedId = viewModel.id
            }
        }).disposed(by: disposeBag)
        
    }
}

