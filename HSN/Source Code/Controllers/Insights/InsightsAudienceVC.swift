//
//  InsightsAudienceVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Charts

class InsightsAudienceVC: UIViewController,ChartViewDelegate {
    @IBOutlet weak var viewChartDiscovery: LineChartView!
    @IBOutlet weak var viewChartLocations: HorizontalBarChartView!
    @IBOutlet weak var viewChartAgeRange: HorizontalBarChartView!
    @IBOutlet weak var viewChartGender: PieChartView!
    @IBOutlet weak var viewChartFollowers: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let discoverySet = LineChartDataSet(entries: [ChartDataEntry(x: 100, y: 200),ChartDataEntry(x: 150, y: 250),ChartDataEntry(x: 200, y: 300)])
        let locationSet = BarChartDataSet(entries: [BarChartDataEntry(x: 100, y: 200),BarChartDataEntry(x: 150, y: 250)])
        let ageSet = BarChartDataSet(entries: [BarChartDataEntry(x: 800, y: 100),BarChartDataEntry(x: 600, y: 200)])
        let genderSet = PieChartDataSet(entries: [PieChartDataEntry(value: 90, label: "Male"),PieChartDataEntry(value: 10, label: "Female")])
        let followersSet = BarChartDataSet(entries: [BarChartDataEntry(x: 100, y: 20),BarChartDataEntry(x: 50, y: 70)])
        
        
        
        discoverySet.mode = .cubicBezier
        discoverySet.cubicIntensity = 0.2
        discoverySet.drawFilledEnabled = true
        discoverySet.drawCirclesEnabled = false
        discoverySet.lineWidth = 0.1
        discoverySet.circleRadius = 4
        discoverySet.setCircleColor(NSUIColor(hexString: "#3A98F2"))
        discoverySet.highlightColor = .init(hexString: "#3A98F2")
        discoverySet.valueTextColor = NSUIColor(hexString: "#3A98F2")
        discoverySet.fillColor = NSUIColor(hexString: "#3A98F2")
        let discoverySetData = LineChartData(dataSet: discoverySet)
        viewChartDiscovery.data = discoverySetData
        viewChartDiscovery.delegate = self
        
        
        
        
        
        locationSet.drawIconsEnabled = false
                 let startColor1 = UIColor(hexString: "#2B78C8")
        locationSet.barBorderWidth = 1
        let startColor2 = UIColor(hexString: "#B6DBFF")
        let startColor3 = UIColor(hexString: "#8BC6FF")
        let startColor4 = UIColor(hexString: "#2B78C8")
        let startColor5 = UIColor(hexString: "#B6DBFF")
                 locationSet.colors =
                     [startColor1, startColor2, startColor3, startColor4, startColor5]
        
        let locationSetData = BarChartData(dataSet: locationSet)
        viewChartLocations.data = locationSetData
        viewChartLocations.delegate = self
        
        
        ageSet.drawIconsEnabled = false
        ageSet.barBorderWidth = 1
        ageSet.colors =
                     [startColor1, startColor2, startColor3, startColor4, startColor5]
        
        let ageSetData = BarChartData(dataSet: ageSet)
        viewChartAgeRange.data = ageSetData
        viewChartAgeRange.delegate = self
        
        
        
        followersSet.drawIconsEnabled = false
        
        followersSet.barBorderWidth = 1
        followersSet.colors =
                     [startColor1, startColor2, startColor3, startColor4, startColor5]
        
        let followersSetData = BarChartData(dataSet: ageSet)
        viewChartFollowers.data = followersSetData
        
       
        viewChartFollowers.delegate = self
        
        
        genderSet.colors = [startColor1,startColor3]
        let genderSetData = PieChartData(dataSet: genderSet)
        //genderSetData.setValueFormatter(Iv)
//        genderSetData.setValueFont(UIFont.SFDisplay(fontSize: 11))
//        genderSetData.setValueTextColor(.white)
               
        viewChartGender.data = genderSetData
      //  viewChartGender.highlightPerTapEnabled = true
        viewChartGender.delegate = self
        
//        set.colors = ChartColorTemplates.joyful()
        


        // Do any additional setup after loading the view.
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
