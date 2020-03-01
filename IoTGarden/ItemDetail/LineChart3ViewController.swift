//
//  LineChart3ViewController.swift
//  ChartsDemo-iOS
//
//  Created by mfv-computer-0019 on 4/26/19.
//  Copyright © 2019 dcg. All rights reserved.
//

import UIKit
import Charts

class LineChart3ViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    let dataLabels = ["22",
                      "333",
                      "444", "555"]
    let values = [1.0, 0.0, 1.0, 0.0]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 3

       
        xAxis.valueFormatter = self
        
        lineChartView.pinchZoomEnabled = true
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true

        
        setDataCount(100, range: UInt32(100))
        
    }
    
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        
        let yVals3 = (0..<values.count).map { (i) -> ChartDataEntry in
            let val = values[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set3 = LineChartDataSet(entries: yVals3, label: "DataSet 3")
//        set3.axisDependency = .left
        set3.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        set3.drawCirclesEnabled = true
        set3.lineWidth = 2
        set3.circleRadius = 5
        set3.fillAlpha = 1
        set3.drawFilledEnabled = true
        set3.fillColor = .blue
        set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set3.drawCircleHoleEnabled = true
        set3.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.lineChartView.leftAxis.axisMinimum)
        }

        
        let data = LineChartData(dataSets: [set3])
        data.setDrawValues(false)
        
        lineChartView.data = data
    }
}

extension LineChart3ViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return dataLabels[Int(value)]
    }
}
