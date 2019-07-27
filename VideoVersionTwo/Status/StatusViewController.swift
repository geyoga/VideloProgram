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
        var chartEntry = [BarChartDataEntry]()

        let data = CoreDataHelper.fetchStatus()
        var counter = 0
        let chartData =  BarChartData()
        for item in data {
            counter += 1
            print(item["techniqueName"]!)
            
            let count: Double = item["count"]! as! Double
            print(count)
            let value = BarChartDataEntry(x: Double(counter), y: count)
            chartEntry.append(value)
            
            let bar = BarChartDataSet(entries: chartEntry, label: item["techniqueName"]! as? String)
            chartData.addDataSet(bar)
        }
        barChart.data = chartData
        barChart.tintColor = UIColor.white
        barChart.gridBackgroundColor = NSUIColor.white
        barChart.chartDescription?.textColor = .white
        barChart.backgroundColor = .gray
        barChart.dragEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.scaleXEnabled = false
        barChart.scaleYEnabled = false
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
