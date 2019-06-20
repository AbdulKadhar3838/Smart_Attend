//
//  BarChartModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 31/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class BarChartModel{
    var arrayBarChart: Array<AnyObject>?
    var isSuccess:  Bool?
    var message: String?
    var deviceStartTime: String?
    var deviceEndTime: String?
    var etaTotalHours : String?
    
    init(jsonData: AnyObject) {
        if let response = (jsonData["barChart"] as? Array<AnyObject>) {
             self.arrayBarChart = response
        }
       
        self.isSuccess = (jsonData["IsSuccess"] as? Bool) ?? false
        self.message = (jsonData["Message"] as? String) ?? ""
        self.deviceStartTime = (jsonData["DeviceStartTime"] as? String) ?? ""
        self.deviceEndTime = (jsonData["DeviceEndTime"] as? String) ?? ""
        self.etaTotalHours = (jsonData["EtaTotalHours"] as? String) ?? ""
        
    }
}

class ArrayBarChart {
    var startDate : String?
    var endDate : String?
    var color : String?
    var task : String?
    var totalHours : String?
    
    
    init(dict:AnyObject) {
        
        self.startDate = (dict["StartDate"] as? String) ?? ""
        self.endDate =  (dict["EndDate"] as? String) ?? ""
        self.color = (dict["Color"] as? String) ?? ""
        self.task =  (dict["Task"] as? String) ?? ""
        self.totalHours = (dict["TotalHours"] as? String) ?? ""

    }
}
