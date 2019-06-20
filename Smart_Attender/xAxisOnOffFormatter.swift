//
//  ChartFormatter.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 07/01/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts

class xAxisOnOffFormatter: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strEffiTimestampYaxis
       // return dateFormatter.string(from: Date(timeIntervalSince1970: value)).substring(from: dateFormatter.string(from: Date(timeIntervalSince1970: value)).index_upper(of: "T")!)
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
   /* public func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let dateFormatter = DateFormatter()
        let graphType:String = defalts.value(forKey: "GraphType") as! String
        if graphType == "HighLow" {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return dateFormatter.string(from: Date(timeIntervalSince1970: value)).substring(from: dateFormatter.string(from: Date(timeIntervalSince1970: value)).index_upper(of: "T")!)
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: Date(timeIntervalSince1970: value)).substring(from: dateFormatter.string(from: Date(timeIntervalSince1970: value)).index_upper(of: " ")!)
        }
    } */
}
