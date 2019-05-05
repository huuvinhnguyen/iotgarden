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
    
    let lineItems = [("1","point1", "on"), ("2","point2", "off"), ("3","point2", "off")]
    
    let dataLabels = ["1288",
                      "12-30",
                      "12-31"]
    
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
        
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult) + 20)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
//        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 50)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 100)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 3600
        
        let from = now - (Double(count) / 2) * hourSeconds
        let to = now + (Double(count) / 2) * hourSeconds
        
        let values = [20.0, 0.0, 20.0, 0.0]
//        let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
//            let y = arc4random_uniform(range) + 50
//            return ChartDataEntry(x: x, y: Double(y))
//        }
        
        
        let yVals3 = (0..<values.count).map { (i) -> ChartDataEntry in
            let val = values[i]
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        
        
        
        let set1 = LineChartDataSet(values: yVals1, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 1
        set1.drawFilledEnabled = true
        set1.fillColor = .gray
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        set1.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.lineChartView.leftAxis.axisMinimum)
        }
    
        
        
        let set2 = LineChartDataSet(values: yVals2, label: "DataSet 2")
        set2.axisDependency = .left
        set2.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        set2.drawCirclesEnabled = false
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 1
        set2.drawFilledEnabled = true
        set2.fillColor = .green
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false
        set2.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(self.lineChartView.leftAxis.axisMinimum)
        }
        
        let set3 = LineChartDataSet(values: yVals3, label: "DataSet 3")
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
        
   
        
//        set2.fillAlpha = 1
//        set2.fill = Fill(linearGradient: gradient2, angle: 90) //.linearGradient(gradient, angle: 90)
//        set2.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [set3])
        data.setDrawValues(false)
        
        lineChartView.data = data
    }
}

extension LineChart3ViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}
