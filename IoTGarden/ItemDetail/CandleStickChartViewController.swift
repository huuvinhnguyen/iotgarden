//
//  CandleStickChartViewController.swift
//  IoTGarden
//
//  Created by Apple on 5/4/19.
//

import UIKit
import Charts

class CandleStickChartViewController: UIViewController {
    
    @IBOutlet var chartView: CandleStickChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDataCount(Int(10), range: UInt32(11))

    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let mult = range + 1
//            let val = Double(arc4random_uniform(40) + mult)
            let val = 30.0
            let high = 20.0
            let low = 15.0
            let open = 5.0
            let close = 10.0
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon"))
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }
    
}

