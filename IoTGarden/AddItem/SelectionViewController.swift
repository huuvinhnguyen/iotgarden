//
//  SelectionViewController.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class SelectionViewController:  UIViewController {
    
     @IBOutlet weak var collectionView: UICollectionView!
    var configuration: Configuration?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    private func prepareNibs() {
        
        collectionView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCell")
    }
    
}

extension SelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
