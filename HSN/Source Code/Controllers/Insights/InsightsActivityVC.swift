//
//  InsightsActivityVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Charts

class InsightsActivityVC: UIViewController,ChartViewDelegate {
    @IBOutlet weak var labelTotalReach: UILabel!
    @IBOutlet weak var labelReach: UILabel!
    @IBOutlet weak var labelImpressions: UILabel!
    @IBOutlet weak var labelTotalInteractions: UILabel!
    @IBOutlet weak var labelProfileVisits: UILabel!
    @IBOutlet weak var labelWebsiteClicks: UILabel!
    @IBOutlet weak var labelEmails: UILabel!
    @IBOutlet weak var viewBarChart: BarChartView!
    @IBOutlet weak var viewBarChartInteractions: BarChartView!
    var discoveryData:[InsightsActivityModel] = []
    var interactionsData:[InsightsActivityModel] = []
    var totalReachCount = ""
    var totalImpressionCount = ""
    var totalInteractionCount = ""
    var profileVisitCount = ""
    var websiteClickCount = ""
    var moreMessagesCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewBarChart.delegate = self
      
        viewBarChartInteractions.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        globalApis.getInsights(contentType: 2, filterType: selectedFilter, from: "", to: "", completion: {
            data  in
           
            self.discoveryData = data["allData"] as! [InsightsActivityModel]
            self.interactionsData = data["interactionData"] as! [InsightsActivityModel]
            self.totalReachCount = data["reachedPostCounts"] as! String
            self.totalImpressionCount = data["reachedImpressionCount"] as! String
            self.profileVisitCount = data["profileVisitCount"] as! String
            self.websiteClickCount = data["websiteClickCounts"] as! String
            self.moreMessagesCount = data["moreMessagesCount"] as! String
           
            
            var dataEntries = [ChartDataEntry]()
            var weeks:[String] = []
            var interactionsEntries = [ChartDataEntry]()
            var interactionsWeeks:[String] = []
            var gap = 10
            for data in self.discoveryData {
                let entry = BarChartDataEntry(x: Double.getDouble(gap), y:  Double.getDouble(data.count))
                gap = gap + 10
                   dataEntries.append(entry)
                weeks.append(data.day)
               }
            
            gap = 10

            for data in self.interactionsData {
                let entry = BarChartDataEntry(x: Double.getDouble(gap), y:  Double.getDouble(data.count))
                gap = gap + 10
                   interactionsEntries.append(entry)
                interactionsWeeks.append(data.day)
               }
            
            let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Weekdays")
            let interactionsDataSet = BarChartDataSet(entries: dataEntries, label: "Weekdays")
               //barChartDataSet.drawValuesEnabled = false
             //  barChartDataSet.colors = ChartColorTemplates.joyful()

               let barChartData = BarChartData(dataSet: barChartDataSet)
            self.viewBarChart.data = barChartData
           // self.viewBarChart.legend.enabled = false
          //  self.viewBarChart.xAxis.drawLabelsEnabled = true
            self.viewBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks )
            self.viewBarChart.xAxis.granularityEnabled = true
            self.viewBarChart.xAxis.granularity = 1
            self.viewBarChart.xAxis.setLabelCount(weeks.count, force: true)
            self.viewBarChart.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)
            
            
            
            
           // selt.colors = ChartColorTemplates.joyful()
            let data = BarChartData(dataSet: interactionsDataSet)
           // self.viewBarChart.data = data
            self.viewBarChartInteractions.data = data
            
            self.labelTotalReach.text = self.totalReachCount
            self.labelReach.text = self.totalReachCount
            self.labelImpressions.text = self.totalImpressionCount
            self.labelEmails.text = self.moreMessagesCount
            self.labelProfileVisits.text = self.profileVisitCount
            self.labelWebsiteClicks.text = self.websiteClickCount
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
