//
//  EfficiencyLineChartModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 31/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class EfficiencyLineChartModel {
    var arrayQtyChart: Array<AnyObject>?
    var isSuccess:  Bool?
    var message: String?
    init(jsonData: AnyObject) {
        if let response = (jsonData["QtyChart"] as? Array<AnyObject>) {
            self.arrayQtyChart = response
        }
        self.isSuccess = (jsonData["IsSuccess"] as? Bool) ?? false
        self.message = (jsonData["Message"] as? String) ?? ""
    }
    
}
    class ArrayQtyChart {
        var period : String?
        var value : String?
        
        init(dict:AnyObject) {
            self.period = (dict["period"] as? String) ?? ""
            self.value =  (dict["value"] as? String) ?? ""
            
        }
}
