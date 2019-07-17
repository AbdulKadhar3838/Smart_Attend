//
//  SlideMenu_ViewController.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class SlideMenu_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var menu_tableview: UITableView!
    
    
    
    var arrayMenuName = ["Device Dashboard","Incident Notifications","Part No. Database","Part Assign","Quick Report","User Settings","Planned Shutdown Settings","Wifi Configuration","Reset Password","Logout"]
    var arrayMenuImage:[UIImage] = [#imageLiteral(resourceName: "Dashboard"),#imageLiteral(resourceName: "notification (1)"),#imageLiteral(resourceName: "Part list"),#imageLiteral(resourceName: "Part Asign"),#imageLiteral(resourceName: "growth"),#imageLiteral(resourceName: "Userrr"),#imageLiteral(resourceName: "settings-1"),#imageLiteral(resourceName: "Wifiii"),#imageLiteral(resourceName: "key"),#imageLiteral(resourceName: "logout")]
    var selectedMenuImg:[UIImage] = [#imageLiteral(resourceName: "Dashboard"),#imageLiteral(resourceName: "notification-1"),#imageLiteral(resourceName: "partList-1"),#imageLiteral(resourceName: "partAssign"),#imageLiteral(resourceName: "quickreport-1"),#imageLiteral(resourceName: "User"),#imageLiteral(resourceName: "Settings"),#imageLiteral(resourceName: "wifi-1"),#imageLiteral(resourceName: "key (1)"),#imageLiteral(resourceName: "logoutt")]
    var arrayViewController:[String] = ["dashboard2_ViewController","dashboard1_ViewController","PartListVC","PartAssignListVC","QuickReportVC","UserListVC","PlannedShutdownVC","HotspotConfigVC","ResetPswd_ViewController","Login_ViewController"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.menu_tableview.tableFooterView=UIView.init(frame: CGRect.zero)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.revealViewController().frontViewController.view.isUserInteractionEnabled=false
        //  self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        roleBasedMenuSettings()
        if isDashboardHomePage {
            self.menu_tableview.reloadData()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.revealViewController().frontViewController.view.isUserInteractionEnabled=true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Local Function
    func roleBasedMenuSettings() {
        if Global.userType.isManager(){
            arrayMenuName = ["Device Dashboard","Incident Notification","Part No. Database","User Settings","Planned Shutdown Settings","Reset Password","Logout"]
            arrayMenuImage = [#imageLiteral(resourceName: "menu_home"),#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "PartList"),#imageLiteral(resourceName: "UserMenu"),#imageLiteral(resourceName: "Setting"),#imageLiteral(resourceName: "Setting"),#imageLiteral(resourceName: "reset"),#imageLiteral(resourceName: "loggout")]
            arrayViewController = ["dashboard2_ViewController","dashboard1_ViewController","PartListVC","UserListVC","PlannedShutdownVC","HotspotConfigVC","ResetPswd_ViewController","Login_ViewController"]
        }
        if Global.userType.isOperator() {
            arrayMenuName = ["Device Dashboard","Incident Notification","Reset Password","Logout"]
            arrayMenuImage = [#imageLiteral(resourceName: "menu_home"),#imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "reset"),#imageLiteral(resourceName: "loggout")]
            arrayViewController = ["dashboard2_ViewController","dashboard1_ViewController","ResetPswd_ViewController","Login_ViewController"]
        }
    }
    
    func Loggout()
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Account/Logout", jsonObj: ["DeviceToken":dfualts.value(forKey: "Device Token") as? String ?? ""], completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        dfualts.setValue(nil, forKey: AccountID)
                    }
                    self.alertview(msgs: (dict.value(forKey: "Message") as? String)!)
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
    
    // MARK: - Tableview Delegate and Data source
    internal func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenuName.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MenuTableViewCell
        
        
        cell.lblTitle.text = arrayMenuName[indexPath.row]
        cell.imgvwIcon.image = arrayMenuImage[indexPath.row]
        
        
        //change bg
        if indexPath.row == 0 {
            // cell.setSelected(true, animated: true)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return Global.ScreenSize.SCREEN_MAX_LENGTH * 0.06
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isDashboardHomePage = indexPath.row == 0 ? true : false

        if let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell {
            cell.imgvwIcon.image = selectedMenuImg[indexPath.row]
            
            if cell.lblTitle.text == "Logout" {
                dfualts.setValue(nil, forKey: AccountID)
                self.Loggout()
                if !Global.userType.isAdmin()  {
                    NotificationCenter.default.removeObserver(self, name: .reload_notific, object: nil) // need to review
                }
            }
            
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: arrayViewController[indexPath.row])
        
        let nc = revealViewController().frontViewController as! UINavigationController
        nc.pushViewController(controller, animated: false)
        revealViewController().pushFrontViewController(nc, animated: true)
        
    }
}
