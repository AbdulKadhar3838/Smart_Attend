//
//  ChartFormatter.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 07/01/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts



class ChartFormatter: NSObject, IAxisValueFormatter{
    var linechart2_array:NSMutableArray=[]
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        if linechart2_array.count>Int(value) {
            let temp:NSDictionary=linechart2_array[Int(value)] as! NSDictionary
            
            var period:String!
            var date:String!
            let graphType:String = defalts.value(forKey: "GraphType") as? String ?? ""
            if graphType == "HighLow" {
                period = (temp.value(forKey: "x") as? String ?? "")
                date = period.substring(from: period.index_upper(of: "T")!)
            }
            else{
               period = (temp.value(forKey: "period") as? String ?? "")
//                date = period.substring(from: period.index(of: " ")!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
                if let dateTime = dateFormatter.date(from: period) {
                    dateFormatter.dateFormat = strEffiTimestampYaxis // for  X Axis
                    date = dateFormatter.string(from: dateTime)
                } else {
                    date = ""
                }

            }
            
            return date
        }
        else
        {
            return "X Axis"
        }
    }
}
