//
//  CellCreator.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class CellCreator {
    
    class func create(cellAt indexPath: IndexPath, with cellViewModel: CellViewModel, collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch cellViewModel {
            
        case is SwitchCellViewModel:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
            cell.display(cellViewModel: cellViewModel)
            return cell
        case is TemperatureDevice:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureCell", for: indexPath) as! TemperatureCell
            cell.display(cellViewModel: cellViewModel)
            return cell
        case is HumidityDevice:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HumidityCell", for: indexPath) as! HumidityCell
            cell.display(cellViewModel: cellViewModel)
            return cell
        case is InputDevice:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemInputValueCell", for: indexPath) as! ItemInputValueCell
            cell.display(cellViewModel: cellViewModel)
            return cell
        default:
            
            return UICollectionViewCell()
        }
    }
}
