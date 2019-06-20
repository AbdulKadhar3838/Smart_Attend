//
//  LeftAxisChartFormatter.swift
//  Smart Attend
//
//  Created by CIPL0008MOBILITY on 19/04/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts

class LeftAxisOnOffFormatter: NSObject, IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        if value == 1 {
            return "ON"
        }
        else if value == 0
        {
            return "OFF"
        }
        else{
            return ""
        }
    }
}
