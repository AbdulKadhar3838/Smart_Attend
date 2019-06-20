//
//  UserListModel.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 30/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class UserListModel {
    var arrayResponseList: Array<AnyObject>?
    var isSuccess:  Bool?
    var message: String?
    var response : String?
    init(jsonData: AnyObject) {
        if let response = (jsonData["ResponseList"] as? Array<AnyObject>) {
            self.arrayResponseList = response
        }
        
        self.isSuccess = (jsonData["IsSuccess"] as? Bool) ?? false
        self.message = (jsonData["Message"] as? String) ?? ""
        self.response    = (jsonData["Response"] as? String) ?? ""
    }
}
class ArrayResponseList {
    var firstName : String?
    var lastName : String?
    var emailAddress: String?
    var password : String?
    var contactNo : String?
    var status : Bool?
    var isEmailNotification : Bool?
    var imageURL : String?
    var vacationDateFrom:String?
    var vacationDateTo:String?
    var userRollID: Int64?
    var accountID:Int64?
    
    
    init(dict:AnyObject) {
        self.firstName = (dict["FirstName"] as? String) ?? ""
        self.lastName =  (dict["LastName"] as? String) ?? ""
        self.emailAddress = (dict["EmailAddress"] as? String) ?? ""
        self.password = (dict["Password"] as? String) ?? ""
        self.contactNo  = (dict["ContactNo"] as? String) ?? ""
        self.status = (dict["Status"] as? Bool) ?? false
        self.isEmailNotification = (dict["IsEmailNotification"] as? Bool) ?? false
        self.imageURL = (dict["Image"] as? String) ?? ""
        self.vacationDateFrom = (dict["VacationDateFrom"] as? String) ?? ""
        self.vacationDateTo = (dict["VacationDateTo"] as? String) ?? ""
        self.userRollID = (dict["UserRoleID"] as? Int64) ?? 0
        self.accountID = (dict["AccountID"] as? Int64) ?? 0
    }
}

