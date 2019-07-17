//
//  QuickPopup.swift
//  SA-ADMIN
//
//  Created by CIPL0590 on 09/07/19.
//  Copyright © 2019 Colan. All rights reserved.
//

import Foundation
public struct QuickPopUp:Codable {
    
    var IsSuccess:Bool?
    var Message:String?
    var QuickRepModel: QuickRepData?
    
}

public struct QuickRepData:Codable {
    
    
    public var QuickReportSettingID:Int
    public var UserID:Int
    public var Description: Bool
    public var ProductionHours: Bool
    public var PartsProduced: Bool
    public var AvgCycle : Bool
    public var Target: Bool
    public var NoOfIncidents: Bool
    public var Scrap: Bool
    public var TotalCost: Bool
    public var TotalValue: Bool
    public var CreatedDate: String
    public var UpdatedDate: String
    public var ColCount: Int
    
}

struct DefaultResponseCodable:Codable {
    let status:String?
    let message:String?
}


