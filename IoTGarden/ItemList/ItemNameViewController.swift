//
//  ItemNameViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/26/19.
//

import UIKit
import ReSwift
import RxCocoa
import RxSwift
import SDWebImage


class ItemNameViewController: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var imageButton: UIButton!
    private let disposeBag = DisposeBag()
    func newState(state: ItemState) {
        itemRelay.accept(state.itemImageViewModel)
    }
    
    private let itemRelay = PublishRelay<ItemImageViewModel>()
    private var itemListViewModel = ItemListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appStore.subscribe(self) { $0.select { $0.listState }.skipRepeats() }
        itemRelay.asObservable()
            .subscribe(onNext: { [weak self] viewModel in
                guard let weakSelf = self else { return }
                
                weakSelf.imageButton.sd_setBackgroundImage(with: URL(string: viewModel.imageUrl), for: .normal, completed: nil)
                weakSelf.itemListViewModel.imageUrlString = viewModel.imageUrl
            })
        .disposed(by: disposeBag)
        
    
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.connection.serverViewController()!
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        let action = ItemState.Action.addItem(item: ItemListViewModel(uuid: UUID().uuidString, name: itemListViewModel.name, imageUrlString: itemListViewModel.imageUrlString))
        appStore.dispatch(action)
    }
    
    @IBAction func pictureButtonTapped(_ sender: Any) {
        let vc = R.storyboard.itemList.itemImageViewController()!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
