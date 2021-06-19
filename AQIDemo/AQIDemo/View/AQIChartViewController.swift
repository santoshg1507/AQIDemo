//
//  AQIChartViewController.swift
//  AQIDemo
//
//  Created by Santosh Gupta on 19/06/21.
//

import UIKit
import Charts

class AQIChartViewController: UIViewController {
    
    @IBOutlet private weak var chartView: BarChartView!
    
    var viewModel: AQIChartViewModelProtocol = AQIChartViewModel()
    
    //property for handling chart
    var barChartEntry = [BarChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AQI Chart of \(viewModel.data?.city ?? "")"
        self.viewModel.setup()
        self.viewModel.delegate = self
        self.loadChart()
    }
    
    func loadChart() {
        if let aqidata =  viewModel.data {
            var i = 0
            for aqi in self.viewModel.aqilist {
                let value = BarChartDataEntry(x: Double(i + 1), y: aqi)
                barChartEntry.append(value)
                i += 1
            }
            let chartDataSet = BarChartDataSet(entries: barChartEntry, label: "AQI")
            let chartData = BarChartData(dataSet: chartDataSet)
            chartView.data = chartData
            chartData.barWidth = Double(0.20/Double(self.viewModel.aqilist.count))

            chartView.chartDescription?.text = "AQI of \(aqidata.city)"
        }
    }

}

//MARK: AQIDataDelegate func
extension AQIChartViewController: AQIDataDelegate {
    
    func aqiDataUpdated() {
        self.loadChart()
    }
    
}
