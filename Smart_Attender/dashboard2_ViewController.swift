//
//  dashboard02_ViewController.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 16/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit


class dashboard2_ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Connected Outlets
    @IBOutlet weak var hours_button: UIButton!
    @IBOutlet weak var logo_imageview: UIImageView!
    @IBOutlet weak var dropdown_button: UIButton!
    @IBOutlet weak var dashboard_Collectionview: UICollectionView!
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var nodata_view: UIView!
    @IBOutlet weak var nodata_labl: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropdownHeightConstraint: NSLayoutConstraint!
    var badgeLbl = UILabel()
    var Notificationcount:Int?

    
    
    // MARK: - Variables
    var timer: Timer!
    var isIpadScreen:Bool!
    var circleCount:CGFloat=2.0
    var machineNameArray:NSMutableArray=[]
    var dropdown_tableview: UITableView!
    let reuseIdentifier = "Dashboard2_CollectionViewCell"
    var dashcurrentOrientation:String = ""
    var dashpieflatOrientation:String = ""
    var Downtime:Bool!
    var NotificationData:String?
    
    
    // TODO: - Need to Cache KDCircularProgress
    
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.NotificationCountApi()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "IBMPlexSans-SemiBold", size: 20)! ,NSAttributedStringKey.foregroundColor: UIColor.white ]
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true);
        self.transitionChanges()
        
        if self.dropdown_tableview == nil {
            self.dropdown()
        }
        if (self.hours_button.titleLabel?.text != "    \(dropdown_array[self.getSelectedHours()-1])")
        {
            self.hours_button.setTitle("    "+dropdown_array[self.getSelectedHours()-1], for: .normal)
            self.DeviceList(forhours: self.getSelectedHours())
        }
        
        
       
    }
    
   override func viewWillAppear(_ animated: Bool) {
       // self.newUpdateAvailable()
         //initView()
        isDashboardHomePage = true
    
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape
        {
            isIpadScreen = true
            circleCount = 3.0
            self.viewHeightConstraint.constant = -64
        }
        else
        {
            isIpadScreen = false
            circleCount = 2.0
            if(Global.IS.IPAD || Global.IS.IPAD_PRO)
            {
                isIpadScreen = true
                circleCount = 3.0
            }
            self.viewHeightConstraint.constant = -64
        }
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.transitionChanges()
        }, completion: nil)
    }
    
    func initView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
        self.blueborder_dynamicradius(forview:self.hours_button, radius:5)
        defalts.setValue(1, forKey: "hours_selected")
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let radius_check:CGFloat = self.view.frame.size.width / 2
        isIpadScreen = false
        if(Global.IS.IPAD || Global.IS.IPAD_PRO)
        {
            isIpadScreen = true
            circleCount = 3.0
        }
        
        self.viewHeightConstraint.constant = -64
        self.logoHeightConstraint.constant = portraitHeight * 0.08967
        self.dropdownHeightConstraint.constant = portraitHeight * 0.04891
        let taplogo: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.Logo_Clicked))
        taplogo.delegate=self
        self.logo_imageview.addGestureRecognizer(taplogo)
        self.hours_button.setTitle("    "+dropdown_array[self.getSelectedHours()-1], for: .normal)
        self.slidemenu_barbtn.isEnabled = true
        // self.newUpdateAvailable()
        self.DeviceList(forhours: self.getSelectedHours())
        
        if UIDevice.current.orientation.isLandscape {
            circleCount = 3.0
        }
//        let logoBtn = UIButton(type: UIButton.ButtonType.custom)
//        logoBtn.setImage(UIImage(named: "Battery_icon"), for: .normal)
//        logoBtn.addTarget(self, action: #selector(self.logoClicked1) , for: .touchUpInside)
//        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
//        let barButton = UIBarButtonItem(customView: logoBtn)
//        self.navigationItem.rightBarButtonItem = barButton
        
        let cusV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        cusV.backgroundColor = UIColor.clear
        
        // notification image
        
        let img = UIImageView.init(frame: CGRect.init(x: cusV.center.x-30, y: cusV.center.y-15, width: 30, height: 30))
        img.image = UIImage.init(named: "Battery_icon")
        img.tintColor = UIColor.white
        cusV.addSubview(img)
        
        // badge counter round
        let roundV = UIView.init(frame: CGRect.init(x: img.frame.origin.x+10, y:img.frame.origin.y-5, width: 35, height: 17.00))
        roundV.layer.cornerRadius = 8
        roundV.layer.masksToBounds = true
        roundV.backgroundColor = UIColor.red
        
      self.badgeLbl = UILabel.init(frame: CGRect.init(x:7, y: 0, width: 20, height: 15.00))
       // self.badgeLbl = UILabel()
        badgeLbl.font = UIFont.init(name: "IBMPlexSans-SemiBold", size: 10)
        badgeLbl.textAlignment = .center
        badgeLbl.textColor = UIColor.white
        badgeLbl.center = CGPoint(x: roundV.center.x, y: badgeLbl.center.y)

       // badgeLbl.center = roundV.center
        
        roundV.addSubview(badgeLbl)
        
        
        cusV.addSubview(roundV)
        
        //btn action
        let btnName = UIButton()
        btnName.frame = cusV.bounds
        btnName.addTarget(self, action: #selector(self.logoClicked1), for: .touchUpInside)
        btnName.setTitle("", for: .normal)
        cusV.addSubview(btnName)
        
        self.view.bringSubview(toFront: btnName)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cusV)
        
        
        
        
        
        
      

       
    }
    @objc func Logo_Clicked()
    {
        self.DeviceList(forhours: self.getSelectedHours())
    }
    
    func transitionChanges()
    {
        self.dashboard_Collectionview?.collectionViewLayout.invalidateLayout()
        self.dashboard_Collectionview.reloadData()
        self.dashboard_Collectionview.layoutIfNeeded()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        //self.dismiss(animated: true, completion: nil)
       // removeAnimate()

        
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    // MARK: - Lcoal Method
    
    func newUpdateAvailable() {
        if isNewVersionAvailable {
            print("inside new version Available")
            alertOkCancel(msgs: "A new version of Smart Attend is available.Please update to version \(releaseVersion) now", handlerCancel: {_ in
                
            }, handlerOk: {_ in
                      if #available(iOS 10.0, *) {
                 UIApplication.shared.open((URL(string: "itms://itunes.apple.com/app/" + appStoreAppID)!), options:[:], completionHandler: nil)
                 } else {
                 // Fallback on earlier versions
                 UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id" + appStoreAppID)!)
                 
                 }
            })
        }
    }
    
    
    // MARK: - Timer Method
    @objc func runTimedCode() {
        self.DeviceListBackgroudFetch(forhours: self.getSelectedHours())
    }
    
    // MARK: - GetAll DeviceList Method
    func DeviceList(forhours: Int)
    {
        if !ifLoading()
        {
            defalts.setValue(forhours, forKey: "hours_selected") //customer_id
            self.nodata_view.isHidden=true
            machineNameArray.removeAllObjects()
            self.startloader(msg: "Loading.... ")
            Global.server.Get(path: "Dashboard/DeviceList/\(customer_id!)/\(forhours)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let dict:NSDictionary=success as! NSDictionary
                    if(dict["IsSuccess"] != nil)
                    {
                        let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                        if (success)
                        {
                            let data:NSArray=dict.value(forKey: "Response") as? NSArray ?? []
                            var boolDowntime:Bool = false
                            
                            let booldata = dict["DownTimeFlag"] as? Bool
                            print(booldata ?? false)
                            
                          
                            self.Downtime = booldata
                            print(self.Downtime)
                            self.machineNameArray=data.mutableCopy() as? NSMutableArray ?? []
                            if self.machineNameArray.count > 0
                            {
                                
                                arrayGlobalMachineName.removeAll()
                                arrayGlobalDeviceIDwtfMachineName.removeAll()
                                for i in 0 ..< self.machineNameArray.count {
                                    if  let dict = self.machineNameArray.object(at: i) as? NSDictionary{
                                      arrayGlobalMachineName.append(dict.value(forKey: "DeviceName") as? String ?? "")
                                        arrayGlobalDeviceIDwtfMachineName.append(dict.value(forKey: "DeviceID") as? Int64 ?? 0)
                                        }
                                    
                                }
                                self.dashboard_Collectionview.isHidden=false
                                
                                self.dashboard_Collectionview.reloadData()
                                self.dashboard_Collectionview.layoutIfNeeded()
                                self.animateCollectionview()
                                let topindexpath:IndexPath = IndexPath(item: 0, section: 0)
                                self.dashboard_Collectionview.scrollToItem(at: topindexpath, at: .top, animated: true)
                                
                            }
                            else
                            {
                                self.nodata_view.isHidden=false
                                self.dashboard_Collectionview.isHidden=true
                            }
                        }
                    }
                }
                else
                {
                    self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
                }
            })
        }
        else
        {
            print("Already Loading")
        }
    }
    func DeviceListBackgroudFetch(forhours: Int)
    {
        if !ifLoading()
        {
            Global.server.Get(path: "Dashboard/DeviceList/\(customer_id!)/\(forhours)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                // Global.server.Get(path: "Dashboard/DeviceList/\(customer_id!)/\(forhours)", jsonOb
                if(failure == nil && noConnection == nil)
                {
                    let dict:NSDictionary=success as! NSDictionary
                    if(dict["IsSuccess"] != nil)
                    {
                        let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                        if (success)
                        {
                            let data:NSArray=dict.value(forKey: "Response") as? NSArray ?? []
                            
                            defalts.setValue(forhours, forKey: "hours_selected")
                            
                            self.nodata_view.isHidden=true
                            self.machineNameArray.removeAllObjects()
                            self.machineNameArray=data.mutableCopy() as? NSMutableArray ?? []
                            if self.machineNameArray.count > 0
                            {
                                
                                arrayGlobalDeviceIDwtfMachineName.removeAll()
                                arrayGlobalMachineName.removeAll()
                                for i in 0 ..< self.machineNameArray.count {
                                    if  let dict = self.machineNameArray.object(at: i) as? NSDictionary{
                                        arrayGlobalMachineName.append(dict.value(forKey: "DeviceName") as? String ?? "")
                                        arrayGlobalDeviceIDwtfMachineName.append(dict.value(forKey: "DeviceID") as? Int64 ?? 0)
                                    }
                                    
                                }
                                self.dashboard_Collectionview.isHidden=false
                                DispatchQueue.main.async {
                                    self.dashboard_Collectionview.reloadData()
                                }
                            }
                            else
                            {
                                self.nodata_view.isHidden=false
                                self.dashboard_Collectionview.isHidden=true
                            }
                        }
                    }
                }
            })
        }
        else
        {
            print("Already Loading")
        }
    }
    func NotificationCountApi(){
        //let jsonURL = "http://smartattend.colanonline.net/service/api/Dashboard/NotificationCountByDeviceID/131"
        let jsonURL = (BaseApi + "Dashboard/NotificationCount/" + account_id)
        print(jsonURL)
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else{
                return
            }
            guard let dd = data else{
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                {
                    self.Notificationcount = json["NotifyCount"] as? Int
                    print("Json Response :",json)
                    if self.Notificationcount ?? 0 >= 99 {
                        DispatchQueue.main.async {
                            
                            self.badgeLbl.text = "99+"
                        }
                    }
                    
                    print("Count :",self.Notificationcount!)
                   //let arr = String(self.NotificationData!)
                }
                
            }
            catch {
                print("Error is : \n\(error)")
            }
            }.resume()
        
    }
    // MARK: - Button Actions
    @IBAction func retry_butn(_ sender: AnyObject) {
        self.DeviceList(forhours: self.getSelectedHours())
    }
    @IBAction func dropdown_button(_ sender: AnyObject?) {
        self.show_dropdown()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return machineNameArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var picDimension:CGFloat = (self.view.frame.size.width / circleCount) - 10
        
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular ) && (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
            picDimension = (self.view.frame.size.width / circleCount) - 13.5
        }  
        
        return CGSize(width: picDimension,height: picDimension)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! Dashboard2_CollectionViewCell
        let data_array:NSDictionary=machineNameArray.object(at: indexPath.row) as! NSDictionary
        cell.machine_namelbl.text =  data_array.value(forKey: "DeviceName") as? String
        cell.circlenumber_label.text="\(data_array.value(forKey: "Count") as? NSNumber ?? 0) INCIDENTS"
        cell.circlenumberlblForNA.text = cell.circlenumber_label.text
        
        
        if let partNO = data_array.value(forKey: "PartNumber") as? String, partNO != ""{
            
            cell.lblPartNumber.text = partNO
            cell.lblCenterLine.isHidden = false
            cell.lblCycleTime.isHidden = false
            cell.imgvwDown.isHidden = false
            cell.lblDowntimeDuration.isHidden = false
            cell.lblCompletedQuantity.isHidden = false
            cell.lblCenterSeparator.isHidden = false
            
            cell.lblEfficiency.isHidden = false
            cell.circlenumber_label.isHidden = false
            cell.machine_statuslbl.isHidden = false
            cell.lblEfficiencyForNA.isHidden = true
            cell.circlenumberlblForNA.isHidden = true
            cell.machineStatuslblForNA.isHidden = true
            
        } else {
            cell.lblPartNumber.text = "Part No. NA"
            cell.lblCenterLine.isHidden = true
            cell.lblCycleTime.isHidden = true
            cell.imgvwDown.isHidden = true
            cell.lblDowntimeDuration.isHidden = true
            cell.lblCompletedQuantity.isHidden = true
            cell.lblCenterSeparator.isHidden = true
            
            cell.lblEfficiency.isHidden = true
            cell.circlenumber_label.isHidden = true
            cell.machine_statuslbl.isHidden = true
            cell.lblEfficiencyForNA.isHidden = false
            cell.circlenumberlblForNA.isHidden = false
            cell.machineStatuslblForNA.isHidden = false
        }
        cell.lblETA.text = data_array.value(forKey: "ETA") as? String
        cell.lblDowntimeDuration.text = data_array.value(forKey: "DowntimeDuration") as? String
        cell.lblEfficiency.text = "\(data_array.value(forKey: "Efficiency") as? NSNumber ?? 0)%"
        print(data_array.value(forKey: "Efficiency") as? NSNumber ?? 0)
        cell.lblEfficiencyForNA.text = cell.lblEfficiency.text
        
        cell.lblCycleTime.text = data_array.value(forKey: "CycleTime") as? String
        cell.lblCompletedQuantity.text = "\(data_array.value(forKey: "CompletedQuantity") as? NSNumber ?? 0)"
        
        
        var statuscolor:UIColor!
        
        let downtimeDurationID = data_array.value(forKey: "DowntimeDurationID") as? NSNumber ?? 0
        if Downtime == true {
            if downtimeDurationID == 2 {
                cell.imgvwDown.image = #imageLiteral(resourceName: "sortDown")
                cell.lblDowntimeDuration.textColor = UIColor.init(netHex: 0xC82E30)
            } else {
                cell.imgvwDown.image = #imageLiteral(resourceName: "sortUp")
                cell.lblDowntimeDuration.textColor = UIColor.init(netHex: 0x51C747)
            }
            
            
        }
        else{
            cell.lblDowntimeDuration.isHidden = true
        }
        
        
        let Alarmstatus:NSNumber=data_array.value(forKey: "Alarm") as? NSNumber ?? 0
        
        let isCommunicating:Bool=data_array.value(forKey: "IsCommunicating") as? Bool ?? false
        let isPlanned:NSNumber=data_array.value(forKey: "IsPlanned") as? NSNumber ?? 0
        let status:NSNumber=data_array.value(forKey: "RunningStatus") as? NSNumber ?? 0
        
    
        if let actionof = Global.machine_status(rawValue: Int(status))
        {
            //            cell.machine_statuslbl.text =  actionof.stringvalue
            //          statuscolor = actionof.color
            
            if status == 0 { //Not Running
                if isPlanned == 0 && !isCommunicating {
                    
                    statuscolor = UIColor.init(netHex: 0xf05254)
                    cell.machine_statuslbl.text =  "STOPPED" //red
                    if  let descriptionId:Int=data_array.value(forKey: "DescriptionID") as? Int {
                        if descriptionId > 3 && descriptionId != 10{
                        
                            if  let description:String = data_array.value(forKey: "Description") as? String {
                                cell.machine_statuslbl.text = description.uppercased()
                                
                            }
                        }
                    }
                } else if isPlanned == 2 && !isCommunicating {
                    
                    statuscolor = UIColor.init(netHex: 0xA9A9A9) //gray
                    cell.machine_statuslbl.text = "PLANNED SHUTDOWN"
                    if  let descriptionId:Int=data_array.value(forKey: "DescriptionID") as? Int {
                            if (descriptionId >= 1  && descriptionId <= 3) || descriptionId == 10 {
                        
                                if  let description:String = data_array.value(forKey: "Description") as? String {
                                    cell.machine_statuslbl.text = description.uppercased()
                                }
                            }
                        }
                } else {
                    if isCommunicating {
                        cell.machine_statuslbl.text =  "COMM ERROR" //blue
                        statuscolor = UIColor.init(netHex: 0x00b9f2)
                    }
                }
                
            } else { //Running
                if isCommunicating {
                    cell.machine_statuslbl.text =  "COMM ERROR" //blue
                    statuscolor = UIColor.init(netHex: 0x00b9f2)
                } else if Alarmstatus == 1 {
                    cell.machine_statuslbl.text =  "ALARM" //yellow
                    statuscolor = UIColor.init(netHex: 0xfaa61a)
                    if  let description:String = data_array.value(forKey: "Description") as? String {
                        cell.machine_statuslbl.text = description.uppercased()
                    }
                } else {
                    cell.machine_statuslbl.text =  "RUNNING" //green
                    statuscolor = UIColor.init(netHex: 0x36B54A)
                }
            }
            
            cell.machineStatuslblForNA.text = cell.machine_statuslbl.text
            cell.machineStatuslblForNA.textColor = statuscolor
            cell.lblCompletedQuantity.textColor = statuscolor
            cell.lblEfficiency.textColor = statuscolor
            cell.lblEfficiencyForNA.textColor = statuscolor
            cell.lblCycleTime.textColor = statuscolor
            cell.machine_statuslbl.textColor = statuscolor
            cell.cellTopView.backgroundColor = statuscolor
            cell.lblCenterSeparator.backgroundColor = statuscolor
            cell.lblCenterLine.backgroundColor = statuscolor
            cell.layer.borderColor = statuscolor.cgColor
            cell.layer.borderWidth = 1.0
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 7
            
            cell.circlenumber_label.textColor=statuscolor
            cell.circlenumberlblForNA.textColor = statuscolor
            
            let angle:Double = 360 * (Double(data_array.value(forKey: "QtyPercentage") as? NSNumber ?? 0 )/100.0)
            cell.circularProgressView.angle = angle
            cell.circularProgressView.trackColor = statuscolor.withAlphaComponent(0.3)
            cell.circularProgressView.progressColors[0] = statuscolor
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if Global.userType.isAdmin() ||  Global.userType.isManager()
        {
            let data_array:NSDictionary=machineNameArray.object(at: indexPath.row) as! NSDictionary
            
            let piechart = self.storyboard?.instantiateViewController(withIdentifier: "PieChart_ViewController") as! PieChart_ViewController
            let device_idstr:String="\(data_array.value(forKey: "DeviceID") as? NSNumber ?? 0)"
            if let devic_name = data_array.value(forKey: "DeviceName") as? String
            {
                defalts.setValue(devic_name, forKey: "Device_Name")
            }
            else
            {
                defalts.setValue("Un Specified", forKey: "Device_Name")
            }
            piechart.device_id=device_idstr
            let Width = UIScreen.main.bounds.size.width
            let Height = UIScreen.main.bounds.size.height
            
            if (Width) > (Height) {
                self.dashpieflatOrientation = "Landscape"//checking Landscape mode
            } else if (Width) < (Height){
                self.dashpieflatOrientation = "Portrait"//checking Portait mode
            }
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                dashcurrentOrientation = "Landscape"
            } else if UIDevice.current.orientation.isPortrait{
                print("Portrait")
                dashcurrentOrientation = "Portrait"
            } else if (UIDevice.current.orientation.isFlat) && (dashpieflatOrientation == "Portrait"){
                dashcurrentOrientation = "FlatPortrait"
            } else if (UIDevice.current.orientation.isFlat) && (dashpieflatOrientation == "Landscape") {
                dashcurrentOrientation = "FlatLandscape"
            }
            
            piechart.piecurrentOrientation = dashcurrentOrientation
            
            
            if let cell = collectionView.cellForItem(at: indexPath) as? Dashboard2_CollectionViewCell {
                piechart.passStatus = cell.machine_statuslbl.text ?? ""
                piechart.passCycletime = cell.lblCycleTime.text ?? "00:00:00"
                piechart.passCompletedQty = cell.lblCompletedQuantity.text ?? "0"
                piechart.passColor = cell.lblEfficiency.textColor
            }
            
            
            self.navigationController?.pushViewController(piechart, animated: true)
        }
    }
    
    // MARK: - Dropdowm Methods
    @objc func dismiss_dropdown() {
        if dropdown_tableview != nil
        {
            if (!dropdown_tableview.isHidden){
                dropdown_tableview.isHidden=true
            }
        }
    }
    @objc func show_dropdown() {
        if dropdown_tableview != nil
        {
            dropdown_tableview.isHidden=false
        }
    }
    func dropdown()
    {
        self.dropdown_tableview = UITableView()
        self.dropdown_tableview.backgroundColor = UIColor.white
        self.dropdown_tableview.tableFooterView = UIView()
        self.dropdown_tableview.isHidden=true
        self.dropdown_tableview.register(UITableViewCell.self, forCellReuseIdentifier: "dropdown_cell")
        self.dropdown_tableview.delegate = self
        self.dropdown_tableview.dataSource = self
        self.dropdown_tableview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(self.dropdown_tableview)
        self.blueborder_dynamicradius(forview:self.dropdown_tableview, radius:2)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss_dropdown))
        tap.delegate=self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.show_dropdown))
        tap2.delegate=self
        tap2.cancelsTouchesInView = false
        dropdown_tableview.addGestureRecognizer(tap2)
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .top, relatedBy: .equal, toItem: self.hours_button, attribute: .bottom, multiplier: 1, constant: -2)
        
        let width_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .width, relatedBy: .equal, toItem: self.hours_button, attribute: .width, multiplier: 1, constant: 0)
        
        let height_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3*self.hours_button.frame.size.height)
        
        let centerhorizontally_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .centerX, relatedBy: .equal, toItem: self.hours_button, attribute: .centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([width_constraint,height_constraint,top_constraint,centerhorizontally_constraint])
    }
    
    // MARK: - CollectionView Animation
    func animateCollectionview() {
        let cells = dashboard_Collectionview.visibleCells
        for i in cells {
            let cell:UICollectionViewCell = i as UICollectionViewCell
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
            
        }
        var index = 0
        
        for a in cells {
            let cell: UICollectionViewCell = a as UICollectionViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: nil)
            
            index += 1
        }
    }
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdown_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dropdown_cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.textColor=theme_color
        cell.textLabel?.font=hours_button.titleLabel?.font
        cell.textLabel?.text = dropdown_array[indexPath.row]
        cell.textLabel?.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropdown_tableview.isHidden=true
        hours_button.setTitle("    "+dropdown_array[indexPath.row], for: .normal)
        
        self.DeviceList(forhours: Int(indexPath.row)+1)
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return hours_button.frame.size.height
    }
}
public extension Int {
    /// Random integer between 0 and n-1.
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random Int point number between 0 and n max
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
}

