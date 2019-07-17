//
//  ScarpResponseModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 22/11/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import Foundation

struct ScarpResponseModel : Codable{
    var IsSuccess : Bool
    var Message : String
    var lstPart : [ScarpResponseList]
    
}

struct ScarpResponseList : Codable {
    var PartId : Int64
    var DeviceID : Int
    var ScrapCount : String
    var PartNumber : String
    var Description :String
    
}
