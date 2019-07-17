//
//  PopupModelClass.swift
//  SA-ADMIN
//
//  Created by CIPL0590 on 05/07/19.
//  Copyright © 2019 Colan. All rights reserved.
//

import Foundation
import UIKit

public struct Notifiacation : Codable{
    
    public var IsSuccess: String
    public var Message: String
    public var LstNotificationDeviceModel: [LstNotificationDeviceModel]!
}

public struct LstNotificationDeviceModel: Codable{
    
    public var ID: Int
    public var DeviceID: Int
    public var DeviceName: String
    public var DeviceDataUserMapID: Int
    public var InputName: String
    public var Notifycount : Int
    public var DeviceNotifycount: Int
    public var Message: String
    public var Color: String
    
}
public struct DashboardNotificationCount : Codable{
    
    public var IsSuccess: String
    public var Message: String
    public var NotifyCount: Int
}
