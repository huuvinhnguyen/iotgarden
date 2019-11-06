//
//  SelectionViewController.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit
import RxDataSources
import RxSwift

class SelectionViewController:  UIViewController {
    
    private var disposeBag = DisposeBag()
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SelectionSection> {
        
        return RxTableViewSectionedReloadDataSource<SelectionSection>(configureCell: { _, tableView, indexPath, viewModel in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.selectionServerCell, for: indexPath) else { return UITableViewCell() }
//            cell.viewModel = viewModel
            
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
    }
    
    var configuration: Configuration?
    var sensorKinds = ["toggle", "temperature", "humidity", "value"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
        loadData()
    }
    
    private func prepareNibs() {
        
//        collectionView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCell")
        tableView.register(R.nib.selectionServerCell)
    }
    
    private func loadData() {
        
        let sections: [SelectionSection] = [
            SelectionSection(title: "", items: [
                .serverItem(viewModel: ServerViewModel()),
                .serverItem(viewModel: ServerViewModel()),
                .serverItem(viewModel: ServerViewModel()),
                .serverItem(viewModel: ServerViewModel()),

                ])
        ]
        
        Observable.just(sections)
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
            vc.configuration = configuration
            vc.kind = sensorKind
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}