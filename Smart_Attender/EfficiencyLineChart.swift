//
//  EfficiencyLineChart.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 06/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts


var strEffiTimestampYaxis = "dd-MMM"
var countEffiAnimation = 0

class EfficiencyLineChart: NSObject,IAxisValueFormatter,ChartViewDelegate {
    
    class func plotLineChart (LineChart:LineChartView,xAxisData: Array<Double>, yAxisData: Array<String>,chartLegend:String,chartColor:String) {
        
        var label_Array:[String] = [chartLegend]
        var data_enteries1: [ChartDataEntry] = []
        
        for i in 0..<yAxisData.count
        {
            data_enteries1.append(ChartDataEntry(x: xAxisData[i] , y: Double(yAxisData[i]) ?? 0.0))
        }
        
        let dataSet = LineChartDataSet(values: data_enteries1, label: label_Array[0])
        dataSet.setColor(UIColor.init(netHex_String: chartColor))
        dataSet.drawCirclesEnabled = true
        dataSet.lineWidth = 1.5
        dataSet.circleRadius = 2
        dataSet.circleColors = [UIColor.init(netHex_String: chartColor)]
        dataSet.mode = .cubicBezier
        
        var dataSets = [IChartDataSet]()
        dataSets.append(dataSet)
        let chart:LineChartView = LineChart
        let lineChartD = LineChartData(dataSets: dataSets)
        
        
        lineChartD.setDrawValues(false)
        
        chart.data = lineChartD
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
       
       
        chart.leftAxis.spaceBottom = 0.0
        chart.leftAxis.axisMinimum = 0.0
       // chart.leftAxis.axisMaximum = 200.0
       // chart.leftAxis.calculate(min: 0.0, max: 60.0) // it set y axis range
        chart.rightAxis.enabled=false
    
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.avoidFirstLastClippingEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity  = 1.0
        chart.xAxis.valueFormatter = EfficiencyLineChart()
        
        chart.chartDescription?.enabled = false
        chart.doubleTapToZoomEnabled=false
        chart.scaleYEnabled = false
        chart.noDataText = "There is no provided data from the server. Please check out later!"
        chart.legend.font = NSUIFont.boldSystemFont(ofSize: 14)
        chart.xAxis.centerAxisLabelsEnabled = true
       
        
        
        var ballonFontSize = 12
       //Customizing Device
        if Global.IS.IPAD_PRO || Global.IS.IPAD {
            chart.legend.formSize = 20
            chart.xAxis.labelFont = UIFont.systemFont(ofSize: 14)
            chart.leftAxis.labelFont = UIFont.systemFont(ofSize: 14)
            ballonFontSize = 14
        }
        
        //Marker
        chart.drawMarkers = true
        let marker : BalloonMarker     = BalloonMarker.init(color: UIColor.lightGray.lighter(by: 6.0)!, font: UIFont.systemFont(ofSize: CGFloat(ballonFontSize)), textColor: UIColor.black, insets: UIEdgeInsetsMake(8, 8, 20, 8),setBarChart:false)
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.chartView = chart
        chart.marker = marker
        chart.legend.enabled = false
        chart.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        //Change Time stamp while it zooming
        if chart.scaleX > 1.0 {
            strEffiTimestampYaxis = "dd-MMM HH:mm"  // Zooming Enabled
           chart.xAxis.labelCount = 4
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
                chart.xAxis.labelCount = 4
            }
        } else  {
            strEffiTimestampYaxis = "dd-MMM"  // No zooming and Scaling
            chart.xAxis.labelCount = 7
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
                chart.xAxis.labelCount = 7
            }
        }
        
        countEffiAnimation == 0 ? chart.animate(xAxisDuration: 2, yAxisDuration: 2) : chart.animate(xAxisDuration: 0, yAxisDuration: 0)
    }
    
    // MARK: - Chart Value Formatter
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strEffiTimestampYaxis // for  X Axis
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
   
}
