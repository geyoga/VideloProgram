//
//  StatusViewController.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import Charts

class StatusViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //setup chart
        let data = CoreDataHelper.fetchStatus()
        var counter = 0
        let chartData =  BarChartData()
        
        for item in data {
            counter += 1
            print(item["techniqueName"]!)
            
            let count: Double = item["count"]! as! Double
            print(count)
            let value = BarChartDataEntry(x: Double(counter), y: count)
            var chartEntry: [BarChartDataEntry] = [BarChartDataEntry]()
            chartEntry.append(value)
            let bar = BarChartDataSet(entries: chartEntry, label: item["techniqueName"]! as? String)
            
            bar.setColors(.init(red: CGFloat(Double(arc4random_uniform(256))/255), green: CGFloat(Double(arc4random_uniform(256))/255), blue: CGFloat(Double(arc4random_uniform(256))/255), alpha: 1.0))
        
            chartData.addDataSet(bar)
        }
        
        chartData.setValueTextColor(.white)
        barChart.data = chartData
        barChart.animate(yAxisDuration: 1.0)
        barChart.tintColor = UIColor.white
        barChart.chartDescription?.textColor = .white
        barChart.noDataText = "Please take any lesson"
        barChart.dragEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
        
        barChart.legend.textColor = .white
    }
}
