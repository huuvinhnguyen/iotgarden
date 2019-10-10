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
    var sensorKinds = ["toggle", "temperature", "humidity", "value"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareNibs()
    }
    
    private func prepareNibs() {
        
        collectionView.register(UINib(nibName: "SelectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectionCell")
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
