//
//  BarChartViewController.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 5/12/19.
//


import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet var chartView: BarChartView!
    var sensor = TopicData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDataCount( 50, range: UInt32(100))

    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 10

        let values = stride(from: 0, to: 4000, by: 1).map { (x) -> BarChartDataEntry in
            let y =  1
            return BarChartDataEntry(x: Double(x), y: Double(y))
        }

        
        let start = 1

        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.values = values
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: values, label: "The year 2019")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false

            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
        
        //        chartView.setNeedsDisplay()
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
//        let itemListService = ItemListService()
//        itemListService.removeSensor(sensor: sensor)
//        itemListStore.dispatch(AddSensorAction())
//        navigationController?.popViewController(animated: true)
    }
}
