//
//  Piechart.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 11/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts

class PiechartModel:NSObject {
    class func plotPieChart (piechart:PieChartView,yValues:[Double],arrayColor:[UIColor]) {
    var yVals1: [ChartDataEntry] = [ChartDataEntry]()
        var firstYvalue:Double = 0.0
    
    for i in 0 ..< yValues.count
    {
        let dataEntry = ChartDataEntry(x: Double(i), y:yValues[i] )
        yVals1.append(dataEntry)
        if i == 0 {
            firstYvalue = yValues[i]
        }
    }
    
    let dataSet: PieChartDataSet = PieChartDataSet(values: yVals1, label: "")
    dataSet.sliceSpace = 1.6
    // add a lot of colors
    dataSet.colors = arrayColor
    dataSet.selectionShift = 7.0
    let data: PieChartData = PieChartData(dataSet: dataSet)
    data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
    data.setValueTextColor(UIColor.clear)
    
    
    piechart.data = data
    piechart.rotationAngle = 270.0
    piechart.highlightValues(nil)
    piechart.chartDescription?.text="" //Chart Data
    piechart.legend.enabled=false
    piechart.noDataText="No data or Empty data provided"
    piechart.holeRadiusPercent = 0.8
    piechart.drawSlicesUnderHoleEnabled = true
    piechart.transparentCircleRadiusPercent = 0.85
    piechart.setExtraOffsets(left: 0, top: 5, right: 0, bottom: 0)
    piechart.highlightValue((Highlight.init(x: 0, y: firstYvalue, dataSetIndex: 0)), callDelegate: true)
   
    
    
    
    if Global.IS.IPHONE_5 {
        dataSet.selectionShift = 5.0
        
    } else if Global.IS.IPAD || Global.IS.IPAD_PRO {
        dataSet.selectionShift = 28.0
        }
    }
    
    
}
