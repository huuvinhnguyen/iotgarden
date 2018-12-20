//
//  CellCreator.swift
//  IoTGarden
//
//  Created by Apple on 12/20/18.
//

import UIKit

class CellCreator {
    
    class func create(cellAt indexPath: IndexPath, with device: Device, collectionView: UICollectionView) -> UICollectionViewCell {
        
        switch device {
            
        case is SwitchDevice:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
            cell.display(device: device)
            return cell
        case is TemperatureDevice:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureCell", for: indexPath) as! TemperatureCell
            cell.display(device: device)
            return cell
        case is HumidityDevice:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HumidityCell", for: indexPath) as! HumidityCell
            cell.display(device: device)
            return cell
        default:
            
            return UICollectionViewCell()
        }
    }
}
