//
//  QuickReportListModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 11/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class QuickReportListModel {
    var isSuccess:Bool?
    var arrayList:[Alist]?
    
    static func valueInitialization(jsonData:[String:AnyObject]) -> QuickReportListModel {
        let quickReportListModel = QuickReportListModel()
        
        if let isSuccess = jsonData["IsSuccess"]
        {
            quickReportListModel.isSuccess = isSuccess as? Bool
        }
        if let responseList = jsonData["LstReportModel"] as? [AnyObject]  {
            
            quickReportListModel.arrayList = responseList.map({Alist.valuePassing(dict: $0)})
        }
        
        return quickReportListModel
    }
}

class Alist {
    
    var machineName:String?
    var partNo:String?
    var description:String?
    var producedHrs:String?
    var partsProduced:Int64?
    var duration:String?
    var expectedProduced:Int64?
    
    var avgCycle:Int64?
    var cycleTime:Int64?
    var OEE:Int64?
    var incidents:Int64?
    var startDate:String?
    var endDate:String?
    var deviceID:Int64?
    
    var incidentStartDate:String?
    var incidentEndDate:String?
    
    var scrap:Int64?
    
    var grossQty:Int64?
    var totalCost:Double?
    var totalValue:Int64?
    
    
    
    
    static func valuePassing(dict:AnyObject) -> Alist {
        let list = Alist()
        
        if  let machineName = dict["MachineName"] as? String {
            list.machineName = machineName
        }
        if let partNo = dict["PartNumber"]  as? String{
            list.partNo = partNo
        }
        if let description = dict["Description"] as? String{
            list.description = description
        }
        if let producedHrs = dict["ProductionHour"] as? String{
            list.producedHrs = producedHrs
        }
        if let partsProduced = dict["PartsProduced"] as? Int64{
            list.partsProduced = partsProduced
        }
        if let expectedProduced = dict["ExpectedProduced"] as? Int64{
            list.expectedProduced = expectedProduced
        }
        if  let duration = dict["Duration"] as? String {
            list.duration = duration
        }
        
        if  let scarp = dict["Scrap"] as? Int64 {
            list.scrap = scarp
        }
        
        if  let avgCycle = dict["AvgCycle"] as? Int64 {
            list.avgCycle = avgCycle
        }
        if  let cycleTime = dict["CycleTime"] as? Int64 {
            list.cycleTime = cycleTime
        }
        if let OEE = dict["EquipEfficency"]  as? Int64{
            list.OEE = OEE
        }
        if let incidents = dict["NoOfIncidents"] as? Int64{
            list.incidents = incidents
        }
        if let startDate = dict["StartDateTime"] as? String{
            list.startDate = startDate
        }
        if let endDate = dict["EndDateTime"] as? String{
            list.endDate = endDate
        }
        if let incidentStartDate = dict["IncidentStartDate"] as? String{
            list.incidentStartDate = incidentStartDate
        }
        if let incidentEndDate = dict["IncidentEndDate"] as? String{
            list.incidentEndDate = incidentEndDate
        }
        if let deviceID = dict["DeviceID"] as? Int64{
            list.deviceID = deviceID
        }
        
        if let grossQty = dict["GrossQty"] as? Int64{
            list.grossQty = grossQty
        }
        if let totalCost = dict["TotalCost"] as? Double{
            list.totalCost = totalCost
        }
        if let totalValue = dict["TotalValue"] as? Int64{
            list.totalValue = totalValue
        }

    
        return list
    }
}

