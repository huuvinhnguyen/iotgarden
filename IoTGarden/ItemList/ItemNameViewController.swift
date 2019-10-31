//
//  ItemNameViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 10/26/19.
//

import UIKit

class ItemNameViewController: UIViewController {
    
    @IBAction func dismissButtonTapped(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.connection.serverViewController()!
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        let action = ListState.Action.addItem()
        appStore.dispatch(action)
    }
    
    @IBAction func pictureButtonTapped(_ sender: Any) {
        let vc = R.storyboard.itemList.itemImageViewController()!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
