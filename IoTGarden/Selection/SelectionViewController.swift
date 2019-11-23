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
    
//    typealias StoreSubscriberStateType = ConnectionState
    
    func newState(state: ConnectionState) {
        
        serversRelay.accept(state.servers)
        
    }
    
    var serversRelay = PublishRelay<[ServerViewModel]>()
    var selectedRelay = PublishRelay<String>()

    
    private var disposeBag = DisposeBag()
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
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
    
    var sensorKinds = ["toggle", "temperature", "humidity", "value"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        
        loadData()

        
        appStore.subscribe(self) { subcription in
            subcription.select { state in state.connectionState }.skipRepeats()
        }
        
        appStore.dispatch(ConnectionState.Action.loadConnections())
        selectedRelay.accept("")

    }
    
    private func prepareNibs() {
        
//        collectionView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCell")
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
        
//        serversRelay
//            .map { $0.map { item in
//
//                SelectionSectionItem.serverItem(viewModel: SelectionServerCell.ViewModel(id: item.id, name:item.name, server: item.url, isSelected: true))} }
//            .map {  sectionItems -> [SelectionSection] in
//                var sections: [SelectionSection] = []
//                sections.append(
//                    SelectionSection(title: "", items: sectionItems)
//                )
//                return sections
//            }
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SelectionSectionItem.self).subscribe(onNext: { [weak self]  sectionItem in
            
            if case  SelectionSectionItem.serverItem(let viewModel) = sectionItem {
                guard let weakSelf = self else { return }
                weakSelf.selectedRelay.accept(viewModel.id)
            }
        }).disposed(by: disposeBag)
        
    }
}

extension SelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sensorKinds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCell", for: indexPath as IndexPath) as! SelectionCell
        let kind = sensorKinds[indexPath.row]
        cell.titleLabel?.text = kind
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier :"AddItemSavingViewController") as? AddItemSavingViewController {
            
            let sensorKind = sensorKinds[indexPath.row]
//            vc.configuration = configuration
            vc.kind = sensorKind
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
