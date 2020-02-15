//
//  TopicTypeViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/27/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TopicTypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        topic?.type = topicName
        appStore.dispatch(TopicState.Action.fetchEditableTopic(topic: topic))
    }
    
    private var topicName = ""
    var topic: Topic? 
    var selectedRelay = PublishRelay<String>()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<Section> {
        
        return RxTableViewSectionedReloadDataSource<Section>(configureCell: { dataSource, tableView, indexPath, viewModel in
            
            switch dataSource[indexPath] {
                
            case .selectionItem(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.topicTypeCell, for: indexPath) else { return UITableViewCell() }
                cell.viewModel = viewModel
                return cell
            }
            }, titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.title
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepairNibs()
        loadData()
        selectedRelay.accept("")
    }
    
    private func loadData() {
        let obs = selectedRelay.flatMapLatest { selectedId -> Observable<[Section]> in
            let section  = Section(title: "", items: [
                .selectionItem(viewModel: TopicTypeCell.ViewModel(id: "1", name: "switch", isSelected: selectedId == "1")),
                .selectionItem(viewModel: TopicTypeCell.ViewModel(id: "2", name: "value", isSelected: selectedId == "2"))
                ])
            return Observable.just([section])
            }
        
        obs
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
        
        tableView.rx.modelSelected(SectionItem.self).subscribe(onNext: { [weak self]  sectionItem in
            
        if case  SectionItem.selectionItem(let viewModel) = sectionItem {
            guard let self = self else { return }
            self.topicName = viewModel.name
            self.selectedRelay.accept(viewModel.id)

            }
        }).disposed(by: disposeBag)
    }
    
    private func prepairNibs() {
        
        tableView.register(R.nib.topicTypeCell)
    }
}
