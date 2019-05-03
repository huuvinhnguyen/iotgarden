//
//  PositiveNegativeBarChartViewController.swift
//  IoTGarden
//
//  Created by mfv-computer-0019 on 5/2/19.
//

import UIKit
import Charts

class PositiveNegativeBarChartViewController: UIViewController {
    
    @IBOutlet var chartView: BarChartView!
    
    let dataLabels = ["12-19",
                      "12-30",
                      "12-31",
                      "01-01",
                      "01-02"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChartData()
        
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = self



        
    }
    
    func setChartData() {
        let yVals = [BarChartDataEntry(x: 0, y: -224.1),
                     BarChartDataEntry(x: 1, y: 238.5),
                     BarChartDataEntry(x: 2, y: 1280.1),
                     BarChartDataEntry(x: 3, y: -442.3),
                     BarChartDataEntry(x: 4, y: -2280.1)
        ]
        
        let red = UIColor(red: 211/255, green: 74/255, blue: 88/255, alpha: 1)
        let green = UIColor(red: 110/255, green: 190/255, blue: 102/255, alpha: 1)
        let colors = yVals.map { (entry) -> NSUIColor in
            return entry.y > 0 ? red : green
        }
        
        let set = BarChartDataSet(values: yVals, label: "Values")
        set.colors = colors
        set.valueColors = colors
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.barWidth = 0.8
        
        chartView.data = data
    }
}

extension PositiveNegativeBarChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}
