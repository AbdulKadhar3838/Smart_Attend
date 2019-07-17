//
//  dashboard1_ViewController.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class dashboard1_ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Connected Outlets
    @IBOutlet weak var machinestatus_tableview: UITableView!
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var nodata_view: UIView!
    @IBOutlet weak var nodata_labl: UILabel!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    var machineNameArray:NSMutableArray=[]
    
   
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        toSetNavigationImagenTitle(titleString:"Incident Notifications", isHamMenu: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload_dashbrd), name: .reload_notific, object: nil)
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
            //revealViewController().panGestureRecognizer()
            //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.machinestatus_tableview.delegate = self
        self.machinestatus_tableview.dataSource = self
        if(!Global.IS.IPAD)
        {
            self.machinestatus_tableview.estimatedRowHeight=80
        }
        else
        {
            self.machinestatus_tableview.estimatedRowHeight=160
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.update_read), name: .Popup_Closed, object: nil)
        self.logoHeightConstraint.constant = portraitHeight * 0.08967
        self.DeviceList(ScrollTop: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        dfualts.setValue(false, forKey: "reload")
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .Popup_Closed, object: nil);
    }
    
    @objc func update_read()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.66) {
            self.RemoveId()
        }
    }
    @objc func reload_dashbrd()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.DeviceList(ScrollTop: false)
        }
    }
 
    func RemoveId() {
        print("RemoveId ==> %d",defalts.value(forKey: "RemoveId"))
        let selected:String=defalts.value(forKey: "RemoveId") as? String ?? ""
        if self.machineNameArray.count == 1
        {
            self.DeviceList(ScrollTop: true)
        }
        else
        {
            self.machineNameArray.removeObject(at: Int(selected)!)
            self.machinestatus_tableview.deleteRows(at: [IndexPath.init(row: Int(selected)!, section: 0)], with: UITableViewRowAnimation.left)
        }
    }
    func DeviceList(ScrollTop:Bool)
    {
        dfualts.setValue(false, forKey: "reload")
        self.nodata_view.isHidden=true
        machineNameArray.removeAllObjects()
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Dashboard/OperatorNotificationList/\(account_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Response"] != nil)
                {
                    //let success=dict.value(forKey: "IsSuccess") as! Bool
                    // if (success)
                    // {
                    let data:NSArray=dict.value(forKey: "Response") as? NSArray ?? []
                    self.machineNameArray=data.mutableCopy() as? NSMutableArray ?? []
                    print(self.machineNameArray.count)
                    if self.machineNameArray.count > 0
                    {
                        self.machinestatus_tableview.isHidden=false
                        self.machinestatus_tableview.reloadData()
                        self.animateTableview()
                        
                        dfualts.setValue(true, forKey: "reload")
                        var topindexpath:IndexPath!
                        if (ScrollTop)
                        {
                            topindexpath = IndexPath(item: 0, section: 0)
                        }
                        else
                        {
                            topindexpath = IndexPath(item: self.machineNameArray.count-1, section: 0)
                        }
                        
                        self.machinestatus_tableview.scrollToRow(at: topindexpath, at: .bottom, animated: true)
                    }
                    else
                    {
                        self.nodata_view.isHidden=false
                        self.machinestatus_tableview.isHidden=true
                    }
                    // }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
        
    }
    
    func animateTableview() {
        let cells = machinestatus_tableview.visibleCells
        let tableWidth:CGFloat = machinestatus_tableview.bounds.size.width
        
        for i in cells {
            let cell:UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
            
        }
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
        
        
    }

    // MARK: - Button Actions
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    @IBAction func retry_butn(_ sender: AnyObject) {
        self.DeviceList(ScrollTop: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func post_notificinfo(indexpath: IndexPath,view: UITableView) {
        let data_array:NSDictionary = machineNameArray.object(at: indexpath.row) as! NSDictionary
        let notific_id:NSNumber=data_array.value(forKey: "NotificationID") as? NSNumber ?? 0
        self.startloader(msg: "Loading.... ")
        let postdict:NSMutableDictionary=["NotificationID":notific_id]
        Global.server.Post(path: "Dashboard/NotificationRead/\(notific_id)", jsonObj: postdict, completionHandler: {
            (success,failure ,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Message"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        defalts.setValue("\(indexpath.row)", forKey: "RemoveId")
                        self.show_popup(indexpath: indexpath,view: view)
                    }
                    else
                    {
                        self.alert(msgs:dict.value(forKey: "Message") as? String ?? "")
                    }
                }
            }
            else
            {
               self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
   
    func show_popup(indexpath: IndexPath, view: UITableView)
    {
        let selectedCell:Dashboard1_TableViewCell = view.cellForRow(at: indexpath)! as! Dashboard1_TableViewCell
        selectedCell.contentView.backgroundColor = selectedCell.contentView.backgroundColor//UIColor.clear
        
        if indexpath.row<=self.machineNameArray.count
        {
        let data_dict:NSDictionary=machineNameArray.object(at: indexpath.row) as! NSDictionary
         dfualts.setValue(false, forKey: "reload")
            
        let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype.lowercased() == "admin") || Global.userType.isManager()
        {
          let popview = self.storyboard?.instantiateViewController(withIdentifier: "MachineDetails_ViewController") as! MachineDetails_ViewController
            popview.data_dict=data_dict
            self.addChildViewController(popview)
            popview.view.frame=self.view.frame
            self.view.addSubview(popview.view)
            popview.didMove(toParentViewController: self)
        }
        else
        {
            let popview2 = self.storyboard?.instantiateViewController(withIdentifier: "Popup_MachinedetailsViewController") as! Popup_MachinedetailsViewController
            popview2.data_dict=data_dict
            self.addChildViewController(popview2)
            popview2.view.frame=self.view.frame
            self.view.addSubview(popview2.view)
            popview2.didMove(toParentViewController: self)
        }
        }
    }
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if Global.IS.IPAD || Global.IS.IPAD_PRO {
        return 100
        } else {
            return 84
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return machineNameArray.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Dashboard1_TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Dashboard1_TableViewCell
        let data_array:NSDictionary=machineNameArray.object(at: indexPath.row) as! NSDictionary
        cell.machine_namelbl.text =  data_array.value(forKey: "DeviceName") as? String
        cell.machine_descrptnlbl.text =  data_array.value(forKey: "Description") as? String
        let status:NSNumber=data_array.value(forKey: "RunningStatus") as? NSNumber ?? 0
        if let actionof = Global.machine_status(rawValue: Int(status))
        {
        cell.machine_statuslbl.text = data_array.value(forKey: "InputName") as? String//actionof.stringvalue
       // cell.machine_statuslbl.textColor = actionof.color
            cell.machine_statuslbl.textColor = UIColor.white
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.post_notificinfo(indexpath: indexPath,view: tableView)
    }
    
}
