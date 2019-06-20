//
//  StackedBarHorizontalChart.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 03/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts


var strBarBaseDate = ""
var strBarTimestampYaxis = "dd-MMM"
var countBarAnimation = 0
var isStartDateSame = true

class StackedBarHorizontalChart: NSObject,IAxisValueFormatter,ChartViewDelegate {
    
    // MARK: - Chart Plotting
    class  func plotChart(barChart:BarChartView,colorActualETA:[UIColor],colorETA:[UIColor],yValuesETA: [Double],yValuesActualETA:[Double],baseDate:String) {
        
        let chart:BarChartView = barChart
        strBarBaseDate = baseDate
        print(yValuesETA)
        
        var yValsBar1 : [BarChartDataEntry] = [BarChartDataEntry]()
        var yValsBar2 : [BarChartDataEntry] = [BarChartDataEntry]()
        let xaxisData = ["ETC"," Req Hrs"]
        
        yValsBar1.append(BarChartDataEntry(x: 0, yValues: yValuesActualETA))
        
        yValsBar2.append(BarChartDataEntry(x: 1, yValues: yValuesETA))
        
        
        let barChartSet1 = BarChartDataSet(values: yValsBar1, label: nil)
        let barChartSet2 = BarChartDataSet(values: yValsBar2, label: nil)
        
        barChartSet1.colors = colorActualETA
        barChartSet1.axisDependency = .left
        
        barChartSet2.colors = colorETA
        barChartSet2.axisDependency = .left
        
        var barDatasets = [IChartDataSet]()
        barDatasets.append(barChartSet1)
        barDatasets.append(barChartSet2)
        
        let data = BarChartData(dataSets: barDatasets)
        chart.data = data
        chart.drawValueAboveBarEnabled = false
        chart.scaleYEnabled = false
        chart.xAxis.granularity = 1
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.axisLineWidth = 1
        chart.xAxis.axisLineColor = .darkGray
        chart.xAxis.xOffset = 8
        
        
        chart.leftAxis.axisMinimum = 0
        chart.leftAxis.enabled = true
        chart.rightAxis.axisMinimum = 0
        chart.rightAxis.drawAxisLineEnabled = true
        chart.rightAxis.drawLabelsEnabled = true
        chart.rightAxis.gridColor = .darkGray
        
        
        chart.chartDescription?.text = ""
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        chart.layer.masksToBounds = true
        chart.layer.cornerRadius = 5
        chart.animate(xAxisDuration: 0, yAxisDuration: 0)
        chart.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        chart.drawValueAboveBarEnabled = false
        chart.clipValuesToContentEnabled = false
        chart.data?.setDrawValues(false)
        chart.legend.enabled = false
        chart.data?.setValueTextColor(UIColor.white)
        
        if chart.scaleX > 1.0 {
            strBarTimestampYaxis = "dd-MMM HH:mm"  // Zooming Enabled
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
            chart.rightAxis.labelCount = 5
            chart.leftAxis.labelCount = 5
            }
        } else  {
            strBarTimestampYaxis = "dd-MMM"  // No zooming and Scaling
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
                chart.rightAxis.labelCount = 7
                chart.leftAxis.labelCount = 7
            }

            
        }
        
        if countBarAnimation == 0 {
            chart.animate(xAxisDuration: 2, yAxisDuration: 2)
        } else {
            chart.animate(xAxisDuration: 0, yAxisDuration: 0)
        }
        
        
        /// Marker
        chart.drawMarkers = true
        let marker : BalloonMarker     = BalloonMarker.init(color: UIColor.lightGray.lighter(by: 6)!, font: UIFont.systemFont(ofSize: 12), textColor: UIColor.black
            , insets: UIEdgeInsetsMake(8, 8, 20, 8),setBarChart:true)
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.chartView = chart
        chart.marker = marker
        
        /// Formatter Assignment
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: xaxisData)
        chart.rightAxis.valueFormatter = StackedBarHorizontalChart()
        chart.leftAxis.valueFormatter = StackedBarHorizontalChart()
        
    
        
        if Global.IS.IPAD_PRO || Global.IS.IPAD {
            chart.setExtraOffsets(left: 40, top: 20, right: 0, bottom: 15)
            data.barWidth = 0.5
            chart.xAxis.labelFont = UIFont.systemFont(ofSize: 12)
            chart.rightAxis.labelFont = UIFont.systemFont(ofSize: 12)
            chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
            chart.barData?.setValueFont(UIFont.systemFont(ofSize: 12.5))
        } else if Global.IS.IPHONE_5 {
            data.barWidth = 0.4
        }else{
            data.barWidth = 0.7
        }
    }
    
    // MARK: - Chart Value Formatter
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strBarTimestampYaxis // for Left and Right Axis
        
        let formatter = DateFormatter()     // For Base date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(value)
        
        let baseDate:Date = formatter.date(from: strBarBaseDate)!
        return dateFormatter.string(from: Date(timeInterval: value, since: baseDate))
    }
}
