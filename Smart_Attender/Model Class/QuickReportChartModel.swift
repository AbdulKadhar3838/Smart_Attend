//
//  QuickReportChartModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 11/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class QuickReportChartModel{
    var isSuccess:Bool?
    var arrayChartDataList:[ChartDataList]?
    var arrayChartTableList:[chartTableList]?

    static func valueInitialization(jsonData:[String:AnyObject]) -> QuickReportChartModel {
        let quickReportChartModel = QuickReportChartModel()

        if let isSuccess = jsonData["IsSuccess"]
        {
            quickReportChartModel.isSuccess = isSuccess as? Bool
        }
        if let responseList = jsonData["pieChart"] as? [AnyObject]  {
            quickReportChartModel.arrayChartDataList = responseList.map({ChartDataList.valuePassing(dict: $0)})
        }
        
        if let responseList = jsonData["LstIncidentResponse"] as? [AnyObject]  {
            
            quickReportChartModel.arrayChartTableList = responseList.map({chartTableList.valuePassing(dict: $0)})
        }

        return quickReportChartModel
    }
}

class ChartDataList {

    var value:String?
    var label:String?
    var input:String?
    var color:String?
    var legend:String?

    static func valuePassing(dict:AnyObject) -> ChartDataList {
        let list = ChartDataList()

        if  let value = dict["value"] as? String {
            list.value = value
        }
        if let label = dict["label"]  as? String{
            list.label = label
        }
        if let input = dict["input"] as? String{
            list.input = input
        }
        if let color = dict["color"] as? String{
            list.color = color
        }
        if let legend = dict["legend"] as? String{
            list.legend = legend
        }
        return list
    }
}

class chartTableList {
    var incident:Int64?
    var inputNmae:String?
    var label:String?

    static func valuePassing(dict:AnyObject) -> chartTableList {
        let list = chartTableList()
        
        if  let incident = dict["Incident"] as? Int64 {
            list.incident = incident
        }
        if let inputNmae = dict["InputName"] as? String{
            list.inputNmae = inputNmae
        }
        if let label = dict["Label"] as? String{
            list.label = label
        }
        return list
    }

}

