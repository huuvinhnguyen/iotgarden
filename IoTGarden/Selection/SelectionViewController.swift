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
    
    typealias StoreSubscriberStateType = ConnectionState
    
    func newState(state: ConnectionState) {
        
        serversRelay.accept(state.servers)
        
    }
    
    var serversRelay = PublishRelay<[ServerViewModel]>()

    
    private var disposeBag = DisposeBag()
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //    @IBOutlet weak var collectionView: UICollectionView!
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

    }
    
    private func prepareNibs() {
        
//        collectionView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCell")
        tableView.register(R.nib.selectionServerCell)
    }
    
    private func loadData() {
        
        serversRelay
            .map { $0.map { SelectionSectionItem.serverItem(viewModel: $0)} }
            .map {  sectionItems -> [SelectionSection] in
                var sections: [SelectionSection] = []
                sections.append(
                    SelectionSection(title: "", items: sectionItems)
                )
                return sections
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
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
