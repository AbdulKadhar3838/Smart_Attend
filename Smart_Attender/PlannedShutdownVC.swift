//
//  PlannedShutdownVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 14/11/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PlannedShutdownVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var viewPopUPExpand: UIView!
    @IBOutlet weak var tableAlert: UITableView!
    @IBOutlet weak var lblEmptyAlert: UILabel!
    @IBOutlet weak var tableStoppedList: UITableView!
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    var stoppedDeviceListModel = StoppedDeviceListModel()
    var arrayRunningList:[String] = []
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var lblPopupBG: UILabel!
    
    //PopUp Expand Collapse
    
    @IBOutlet weak var tableExpandCollapse: UITableView!
    var checkedSection:Int = 0
    var subCheckboxValue:Int64 = 0
    var data_dict: NSDictionary=[:]
    var selectedStoppedList = 0
    var selectedDeviceName = ""
    var isFirstTimeLoaded:Bool = false
    
    
    //Planned Shutdown Expand Collapse
    var isChangeOver:Bool = false
    var isOtherDowntime:Bool = false
    var isOtherShutdown:Bool = false
    var actualSectionNo = 0
    var noOfSection = 3
    var rowsInSectionOne = 0
    var rowsInSectionTwo = 0
    var selectedSection = 4 // noOfSection
    var arrayPlannedData:[String] = []
    var arrayUnplannedData:[String] = []
    var arrayPlannedID:[Int64] = []
    var arrayUnplannedID:[Int64] = []
    var deviceID = ""
    var notificationListModel = NotificationListModel()
    var otherDowntime = ""
    var otherShutdown = ""
    var changeOverSpelling = ""
    var selectedPlanned:[Bool] = []
    var selectedUnPlanned:[Bool] = []
    var popExpandHeight:CGFloat = 0
    var isFirstTimePopExpand = true
    var otherCellHeight:CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        callingViewDidload()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.dismissKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        plannedShutdownListApi()
        isFirstTimeLoaded = true
        isFirstTimePopExpand = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callingViewDidload() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        toSetNavigationImagenTitle(titleString:"Downtime Reason", isHamMenu: true)
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        self.tableStoppedList.isHidden = true
        tableStoppedList.tableFooterView = UIView(frame: CGRect.zero)
        tableStoppedList.layoutMargins = .zero
        tableStoppedList.separatorInset = .zero
        self.tableAlert.tableFooterView = UIView(frame: CGRect.zero)
        
        callingViewDidloadForExpand()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func alertClose() {
        self.lblPopupBG.isHidden = true
        self.viewPopUp.isHidden = true
        for case let switchPlanned as UISwitch in self.view.subviews {
            switchPlanned.setOn(false, animated: true)
        }
        self.plannedShutdownListApi()
    }
    
    func animateTableview() {
        let cells = tableStoppedList.visibleCells
        let tableWidth:CGFloat = tableStoppedList.bounds.size.width
        
        var row = 0
        for i in cells {
            let cell:UITableViewCell = i as UITableViewCell
            if row % 2 == 0 {
                cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
            } else {
                cell.transform = CGAffineTransform(translationX: -tableWidth, y: 0)
            }
            row += 1
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
    
    func emptyExpandTableview() {
        let cells = tableExpandCollapse.visibleCells
        for i in cells {
            let cell:UITableViewCell = i as UITableViewCell
            for case let btn as UIButton in cell.contentView.subviews {
                btn.isSelected = false
            }
            for case let txd as UITextField in cell.contentView.subviews {
                txd.isHidden = true
            }
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    
    @IBAction func isAllMachineShutsown(_ sender: UISwitch) {
        if sender.isOn {
            alertOkCancel(msgs: "Do you want apply Planned Shutdown for all Machines", handlerCancel: {_ in
                sender.setOn(false, animated: true)
                
            }, handlerOk: {_ in
                self.plannedAlldeviceApi()
            })
        }
        
    }
    @IBAction func plannedShutdownAction(_ sender: UIButton) {
        //        let notification = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        //        self.navigationController?.pushViewController(notification, animated: true)
       // self.tableExpandCollapse = nil
        self.viewPopUPExpand.isHidden = false
        self.lblPopupBG.isHidden = false
        selectedStoppedList = sender.tag
        if let list = self.stoppedDeviceListModel.arrayList{
            selectedDeviceName =  list[sender.tag].deviceName ?? ""
            if let deviceID:Int64 = list[sender.tag].deviceID {
                if isFirstTimePopExpand {
                    notificationListApi(deviceID:deviceID)
                } else {
                    self.tableExpandCollapse.isHidden = false
                }
                
        }
        }
        
        
        self.viewPopUPExpand.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3,
                       animations: {
                self.viewPopUPExpand.transform = CGAffineTransform.identity
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.4) {
                            self.viewPopUPExpand.transform = CGAffineTransform.identity
                        }
        })
    }
    
    
    @IBAction func closingPopupExpandCollaspe(_ sender: UIButton) {
        
        for i in 0..<self.selectedPlanned.count {
            self.selectedPlanned[i] = false
        }
        for i in 0..<self.selectedUnPlanned.count {
            self.selectedUnPlanned[i] = false
        }
        otherDowntime = ""
        otherShutdown = ""
        subCheckboxValue = 0
        checkedSection = 0
        
        emptyExpandTableview()
        self.viewPopUPExpand.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.viewPopUPExpand.transform = CGAffineTransform(scaleX:0.0001, y: 0.0001)
                        self.viewPopUPExpand.isHidden = true
                        self.lblPopupBG.isHidden = true
                        
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0) {
                            
                            
                            self.viewPopUPExpand.transform = CGAffineTransform.identity
                        }
        })
    }
    
    @IBAction func popupExpandOK(_ sender: UIButton) {
        print("This is awesome")
        if subCheckboxValue == 0 {
            self.alert(msgs: "Choose the Checkbox")
        }
        self.post_settings(indexPath: selectedStoppedList)
    }
    // MARK: - Tableview Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.tableStoppedList == tableView {
            return 1
            
        } else if self.tableExpandCollapse == tableView{
            return 3
            
        }else {
            return 2
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.tableStoppedList == tableView {
            if let array = stoppedDeviceListModel.arrayList {
                return array.count
            } else {
                return 0
            }
        } else if self.tableExpandCollapse == tableView {
            if section == 0 {
                return rowsInSectionOne
            } else if section == 1{
                return rowsInSectionTwo
            } else {
                return 0
            }
        }else {
            if section == 0 {
                return arrayRunningList.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableStoppedList == tableView {
            let cellIdentifier = "PlannedShutdownCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlannedShutdownCell
            cell.layoutMargins = .zero
            if let array = self.stoppedDeviceListModel.arrayList {
                if let deviceID = array[indexPath.row].deviceID {
                    cell.lblDeviceID.text = "\(deviceID)"
                } else {
                     cell.lblDeviceID.text = ""
                }
                if let deviceName = array[indexPath.row].deviceName {
                    cell.lblDeviceName.text = deviceName
                } else {
                    cell.lblDeviceName.text = ""
                }
                cell.btnAction.tag = indexPath.row
            }
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.init(netHex: 0xF1F1F1)
            }
            
            return cell
            
        } else if self.tableExpandCollapse == tableView {
            
            let cellIdentifier = "ExpandCollapseCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpandCollapseCell
          
            
            
            cell.btnText.addTarget(self, action: #selector(self.insideCheckBoxTapping), for: .touchUpInside)
            cell.btnCheckBox.isSelected = false
            cell.txtField.isHidden = true
            cell.txtField.layer.borderWidth = 1
            cell.lblCheckbox.text = ""
            self.anycolorborder(forview: cell.txtField, radius: 4,color: UIColor.darkGray)
            
            
            if indexPath.section == 0 {
                cell.lblCheckbox.text = self.arrayPlannedData[indexPath.row]
                cell.btnCheckBox.tag = indexPath.row
                cell.btnText.tag = indexPath.row
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
                cell.btnCheckBox.isSelected = selectedPlanned[indexPath.row]
                cell.btnText.isSelected = selectedPlanned[indexPath.row]
                
                if let row =  arrayPlannedData.index(of: "Other"),row ==  indexPath.row{
                if selectedPlanned[row]
                {
                    cell.txtField.text = ""
                    cell.txtField.isHidden = false
                    cell.txtField.becomeFirstResponder()
                    
                } else {
                    cell.txtField.isHidden = true
                    cell.txtField.resignFirstResponder()
                    }
                } else {
                    cell.txtField.isHidden = true
                    cell.txtField.resignFirstResponder()
                }
                
            }
            if indexPath.section == 1 {
                cell.lblCheckbox.text = self.arrayUnplannedData[indexPath.row]
                cell.btnCheckBox.tag = indexPath.row
                cell.btnText.tag = indexPath.row
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
                cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
                cell.btnCheckBox.isSelected = selectedUnPlanned[indexPath.row]
                cell.btnText.isSelected = selectedUnPlanned[indexPath.row]
                
                if let row =  arrayUnplannedData.index(of: "Other"),row ==  indexPath.row {
                if selectedUnPlanned[row]
                {
                    cell.txtField.text = ""
                    cell.txtField.isHidden = false
                    cell.txtField.becomeFirstResponder()
                    
                } else {
                    cell.txtField.isHidden = true
                    cell.txtField.resignFirstResponder()
                    }
                } else {
                    cell.txtField.isHidden = true
                    cell.txtField.resignFirstResponder()
                }
                
            }
            return cell
            
        }  else {
            let cellIdentifier = "ExpandCollapseCellAlert"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpandCollapseCell
            
            if indexPath.section == 0 {
                cell.lblCheckbox.text = self.arrayRunningList[indexPath.row]
                return cell
            }
            
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableStoppedList == tableView {
            return 0.0
        } else if self.tableExpandCollapse == tableView {
            
                return 45.0
            
        }else {
            if section == 1 {
                return 80.0
            } else {
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tableExpandCollapse{
            print(indexPath)
            if indexPath.section == 0 {
            let row =  arrayPlannedData.index(of: "Other")
                if row == indexPath.row {
                    return otherCellHeight //70
                }
                
            }
            if indexPath.section == 1 {
               let row =  arrayUnplannedData.index(of:"Other" )
                if row == indexPath.row {
                    return otherCellHeight //70
                }
            }
            return 30
        } else{
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableStoppedList == tableView {
            return UIView(frame: CGRect.zero)
        } else if self.tableExpandCollapse == tableView {
            if section != 2 {
                let header = tableView.dequeueReusableCell(withIdentifier: "ExpandHeaderCell")! as! ExpandHeaderCell
                
                header.btnText.tag = section
                
                if section == 0 {
                    header.lblCheckbox.text = "Planned Machine Shutdown"
                    if selectedSection == section {
                        header.btnCheckBox.isSelected = true
                        header.btnText.isSelected = true
                    }
                
                } else
                {
                    header.lblCheckbox.text = "Unplanned Machine Shutdown"
                    if selectedSection == section {
                        header.btnCheckBox.isSelected = true
                        header.btnText.isSelected = true
                    }
                }
                
                if Global.IS.IPAD || Global.IS.IPAD_PRO {
                    header.lblCheckbox.font = UIFont.systemFont(ofSize: 22)
                } else {
                    header.lblCheckbox.font = UIFont.systemFont(ofSize: 12)
                }
                
                return header.contentView
            }
            else {
                let header = tableView.dequeueReusableCell(withIdentifier: "OKCell")! as! OKCell
                header.btnOK.titleLabel?.font = UIFont.systemFont(ofSize: 22)
                header.btnOK.setTitle("OK", for: .normal)
                header.btnOK.tag = 2
                header.btnOK.layer.cornerRadius = 8
                header.btnOK.layer.masksToBounds = true
                
                return header.contentView
            }
            
        }else {
            if section == 1{
                let header = tableView.dequeueReusableCell(withIdentifier: "OKCellAlert")! as! OKCell
                header.btnOK.titleLabel?.font = UIFont.systemFont(ofSize: 22)
                header.btnOK.setTitle("OK", for: .normal)
                header.btnOK.addTarget(self, action: #selector(alertClose), for: .touchUpInside)
                header.btnOK.tag = 2
                header.btnOK.layer.cornerRadius = 8
                header.btnOK.layer.masksToBounds = true
                return header.contentView
            } else {
                return UIView(frame: CGRect.zero)
            }
        }
    }
    
    
    // MARK: - GetAll DeviceList Method
    func plannedShutdownListApi()
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/StoppedDeviceList/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    if (success)
                    {
                        self.stoppedDeviceListModel =  StoppedDeviceListModel.valueInitialization(jsonData: dict)
                        if let array = self.stoppedDeviceListModel.arrayList {
                            if array.count > 0 {
                                self.tableStoppedList.isHidden = false
                                self.lblEmptyAlert.isHidden = true
                                self.tableStoppedList.reloadData()
                                
                                
                                
                                if self.isFirstTimeLoaded {
                                    self.isFirstTimeLoaded = false
                                    self.animateTableview()
                                }

                            } else {
                                self.tableStoppedList.isHidden = true
                                self.lblEmptyAlert.isHidden = false
                            }
                        } else {
                            self.tableStoppedList.isHidden = true
                            self.lblEmptyAlert.isHidden = false
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
    func plannedAlldeviceApi()
    {
        
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/PlannedAllDevices/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as! Bool
                    if (success)
                    {
                        self.arrayRunningList.removeAll()
                        let arrayResponselist:[AnyObject] = dict["Response"] as! [AnyObject]
                        for element in arrayResponselist {
                            self.arrayRunningList.append(element["DeviceName"] as? String ?? "")
                        }
                        print(self.arrayRunningList)
                        self.lblPopupBG.isHidden = false
                        self.viewPopUp.isHidden = false
                        self.tableAlert.reloadData()
                      
                        
                    } else {
                        self.alert(msgs: "Unable to shutdown all device right now")
                        self.lblPopupBG.isHidden = false
                        self.viewPopUp.isHidden = false
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
    
    
}

extension PlannedShutdownVC:UITextFieldDelegate
{
    // MARK: - notificationListApi
    func notificationListApi(deviceID:Int64)
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Dashboard/PlannedShutdownDescription/\(deviceID)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                if let dict = success as? [String : AnyObject] {
                    if(dict["IsSuccess"] != nil)
                    {
                        let success = dict["IsSuccess"] as? Bool ?? false
                        if (success)
                        {
                            self.notificationListModel.arrayList?.removeAll()
                            self.arrayPlannedData.removeAll()
                            self.arrayUnplannedData.removeAll()
                            self.notificationListModel = NotificationListModel .valueInitialization(jsonData: dict)
                            
                            
                            if let array = self.notificationListModel.arrayList{
                                if array.count > 0 {
                                    
                                    self.tableExpandCollapse.isHidden = false
                                    self.toLoadExpandCollapse()
                                } else {
                                    self.tableExpandCollapse.isHidden = true
                                    self.showNodata(msgs: "Oops! There is no data in Notification List")
                                }
                            }
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
    
  // MARK: - Local Functions
    func toLoadExpandCollapse() {
        if let array = notificationListModel.arrayList{
            if let arrayEntity:[Int] = array.map({$0.entityType}) as? [Int] {
                if let description = array.map({$0.description}) as? [String],let masterID:[Int64] = array.map({$0.plannedShutdownMasterID}) as? [Int64], let id = array.map({$0.id}) as? [Int64] {
                    isFirstTimePopExpand = false
                    selectedPlanned.removeAll()
                    selectedUnPlanned.removeAll()
                    for i in 0..<arrayEntity.count {
                        if arrayEntity[i] == 1 {
                            arrayPlannedID.append(id[i])
                            selectedPlanned.append(false)
                            if masterID[i] == 10 {
                                arrayPlannedData.append("Other")
                            } else {
                                arrayPlannedData.append(description[i])
                                
                            }
                            
                        }
                        if arrayEntity[i] == 2 {
                            arrayUnplannedID.append(id[i])
                            selectedUnPlanned.append(false)
                            if masterID[i] == 11 {
                                arrayUnplannedData.append("Other")
                            } else {
                                arrayUnplannedData.append(description[i])
                            }
                            
                        }
                        if masterID[i] == 2 {
                            changeOverSpelling = description[i]
                        }
                    }
                }
            }
        }
        print(arrayPlannedData)
        print(arrayUnplannedData)
    }
    
    func callingViewDidloadForExpand() {
        
        self.tableExpandCollapse.delegate = self
        self.tableExpandCollapse.dataSource = self
    }
    

    @objc func insideCheckBoxTapping(_ sender: UIButton) {
        print(sender.tag)
        
        isChangeOver = false
        sender.isSelected = !sender.isSelected
        otherDowntime = ""
        otherShutdown = ""
        subCheckboxValue = 0
        otherCellHeight = 30
        isOtherDowntime = false
        isOtherShutdown = false
        
        
        
        if let cell = sender.superview?.superview as? ExpandCollapseCell {
            cell.btnCheckBox.isSelected =  !cell.btnCheckBox.isSelected
            cell.txtField.isHidden = true
            self.dismissKeyboard()
            self.viewPopUPExpand.transform = CGAffineTransform.identity
            
            if sender.isSelected {
                if checkedSection == 2 {
                    selectedPlanned[sender.tag] = true
                }
                if checkedSection == 3 {
                    selectedUnPlanned[sender.tag] = true
                }
                if let indexpath = tableExpandCollapse.indexPath(for: cell) {
                    if indexpath.section == 1 {
                        
                        for i in 0..<arrayUnplannedData.count where i != sender.tag{
                            let indexpath:IndexPath = IndexPath.init(row: i, section: 1)
                            let cell = self.tableExpandCollapse.cellForRow(at: indexpath) as? ExpandCollapseCell
                            cell?.btnText.isSelected = !sender.isSelected
                            cell?.btnCheckBox.isSelected = !sender.isSelected
                            cell?.txtField.isHidden = true
                            selectedUnPlanned[i] = false
                           
                        }
                        isOtherDowntime = false
                        if cell.lblCheckbox.text == "Other" {
                            cell.txtField.isHidden = false
                            isOtherDowntime = true
                            
                            cell.txtField.text = ""
                           // cell.txtField.becomeFirstResponder()
                            
                            tableExpandCollapse.beginUpdates()
                            otherCellHeight = 70
                            tableExpandCollapse.reloadRows(at: [indexpath], with: .none)
                            tableExpandCollapse.endUpdates()

                            
                        }
                        subCheckboxValue = arrayUnplannedID[sender.tag]
                        
                        
                    } else {
                        
                        for i in 0..<arrayPlannedData.count where i != sender.tag{
                            let indexpath:IndexPath = IndexPath.init(row: i, section: 0)
                            let cell = self.tableExpandCollapse.cellForRow(at: indexpath) as? ExpandCollapseCell
                            cell?.btnCheckBox.isSelected = !sender.isSelected
                            cell?.btnText.isSelected = !sender.isSelected
                            cell?.txtField.isHidden = true
                             selectedPlanned[i] = false
                        }
                        subCheckboxValue = arrayPlannedID[sender.tag]
                        isOtherShutdown = false
                        if cell.lblCheckbox.text == "Other" {
                            cell.txtField.isHidden = false
                            isOtherShutdown = true
                            
                            cell.txtField.text = ""
                           // cell.txtField.becomeFirstResponder()
                            
                            tableExpandCollapse.beginUpdates()
                            otherCellHeight = 70
                            tableExpandCollapse.reloadRows(at: [indexpath], with: .none)
                            tableExpandCollapse.endUpdates()
                        }
                        if let changeOVer = cell.lblCheckbox.text {
                            if changeOVer.contains(self.changeOverSpelling) {
                                isChangeOver = true
                            }
                        }
                    }
                }
            } else {
                if checkedSection == 2 {
                    selectedPlanned[sender.tag] = false
                }
                if checkedSection == 3 {
                    selectedUnPlanned[sender.tag] = false
                }
                
                if let indexpath = tableExpandCollapse.indexPath(for: cell) {
                    if cell.lblCheckbox.text == "Other"
                    {
                        tableExpandCollapse.beginUpdates()
                        otherCellHeight = 30
                        tableExpandCollapse.reloadRows(at: [indexpath], with: .none)
                        tableExpandCollapse.endUpdates()
                    }
                }
            }
        }
    }
    
   
    
    
    @IBAction func sectionTapping(_ sender: UIButton) {
        checkedSection = 0
        otherCellHeight = 30
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedSection = sender.tag
            tableExpandCollapse.reloadData()
            tableExpandCollapse.beginUpdates()
            if sender.tag == 0 {
                checkedSection = 2
                
                for i in 0..<selectedUnPlanned.count {
                    selectedUnPlanned[i] = false
                }
                for i in 0..<selectedPlanned.count {
                    selectedPlanned[i] = false
                }
                if tableExpandCollapse.numberOfRows(inSection: sender.tag) != arrayPlannedData.count {
                    rowsInSectionOne = arrayPlannedData.count
                    var indexpath:[IndexPath] = []
                    for i in 0..<arrayPlannedData.count {
                        indexpath.append(IndexPath.init(row: i, section: 0))
                    }
                    tableExpandCollapse.insertRows(at: indexpath, with: .none)
                }
                
                collapseSectionTwo()
                
            } else {
                checkedSection = 3
                for i in 0..<selectedPlanned.count {
                    selectedPlanned[i] = false
                }
                for i in 0..<selectedUnPlanned.count {
                    selectedUnPlanned[i] = false
                }
                rowsInSectionTwo = arrayUnplannedData.count
                if tableExpandCollapse.numberOfRows(inSection: sender.tag) != arrayUnplannedData.count {
                    var indexpath:[IndexPath] = []
                    for i in 0..<arrayUnplannedData.count {
                        indexpath.append(IndexPath.init(row: i, section: 1))
                    }
                    tableExpandCollapse.insertRows(at: indexpath, with: .none)
                }
                
                collapseSectionOne()
                
            }
            tableExpandCollapse.endUpdates()
        } else {
            selectedSection = noOfSection + 1
            tableExpandCollapse.reloadData()
            tableExpandCollapse.beginUpdates()
            collapseSectionOne()
            collapseSectionTwo()
            tableExpandCollapse.endUpdates()
            
        }
        
    }
    func collapseSectionOne(){
        if tableExpandCollapse.numberOfRows(inSection: 0) == arrayPlannedData.count {
            rowsInSectionOne = 0
            var indexpath:[IndexPath] = []
            for i in 0..<arrayPlannedData.count {
                indexpath.append(IndexPath.init(row: i, section: 0))
            }
            tableExpandCollapse.deleteRows(at: indexpath, with: .none)
        }
    }
    func collapseSectionTwo(){
        if tableExpandCollapse.numberOfRows(inSection: 1) == arrayUnplannedData.count {
            rowsInSectionTwo = 0
            var indexpath:[IndexPath] = []
            for i in 0..<arrayUnplannedData.count {
                indexpath.append(IndexPath.init(row: i, section: 1))
            }
            tableExpandCollapse.deleteRows(at: indexpath, with: .none)
        }
    }
    
    

    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let diffHeight = (self.view.frame.size.height - keyboardHeight) - self.viewPopUPExpand.frame.size.height
            popExpandHeight = self.viewPopUPExpand.frame.origin.y
            UIView.animate(withDuration: 0.3,
                           animations: {
                           
                            self.viewPopUPExpand.frame.origin.y = diffHeight
            },
                           completion: nil)
            
        }
    }
    @objc func keyboardWillShow_Hide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        
                        self.viewPopUPExpand.frame.origin.y = self.popExpandHeight
        },
                       completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        otherDowntime = ""
        otherShutdown = ""
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isOtherDowntime {
            otherDowntime = textField.text ?? ""
        }
        if isOtherShutdown {
            otherShutdown = textField.text ?? ""
        }
    }
    
    func changeOverAlertShowing() {
        let alertController = UIAlertController(title: "Smart Attend", message: "Successfully Applied. Do you want to assign part number? ", preferredStyle: .alert)
        
        let YesAction = UIAlertAction(title: "Yes", style:.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            let UpdateAssignVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAssignVC") as! UpdateAssignVC
            
            UpdateAssignVC.passLabelName =  self.selectedDeviceName
            UpdateAssignVC.istransitFromNotification = true
            self.navigationController?.pushViewController(UpdateAssignVC, animated: true)
        }
        alertController.addAction(YesAction)
        
        let cancelbuttonAction = UIAlertAction(title: "Cancel", style:.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed No")
        }
        alertController.addAction(cancelbuttonAction)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.tableExpandCollapse
            popoverPresentationController.sourceRect = self.tableExpandCollapse.frame
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Post For Expand n Collapse
    func post_settings(indexPath:Int) {
        self.startloader(msg: "Loading.... ")
        
    
        var deviceID:Int64 = 0
        if let list = stoppedDeviceListModel.arrayList {
            deviceID = list[indexPath].deviceID ?? 0
        }
        let postdict:NSMutableDictionary=[
            "MachineShutdown": checkedSection != 2 ? 0 : 2,
            "MachineDowntime": checkedSection != 3 ? 0: 3 ,
            "OtherDowntime": otherDowntime,
            "OtherShutdown":otherShutdown,
            "PlannedDescription": subCheckboxValue != 0 ? subCheckboxValue: 0,
            "DeviceID": deviceID
        ]
        Global.server.Post(path: "Part/SetPlannedorDowntime", jsonObj: postdict, completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let msgs:String!=dict.value(forKey: "Message") as? String
                    
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        if (self.isChangeOver) {
                            self.changeOverAlertShowing()
                        } else {
                            if(msgs.characters.count>0)
                            {
                                self.alert(msgs: (dict.value(forKey: "Message") as? String ?? ""))
                            }
                            else
                            {
                                self.alert(msgs:"Updated Succesfully")
                            }
                        }
                        self.viewPopUPExpand.isHidden = true
                        self.lblPopupBG.isHidden = true
                        self.plannedShutdownListApi()
                    }
                    else
                    {
                        if(msgs.characters.count>0)
                        {
                            self.alert(msgs: (dict.value(forKey: "Message") as? String ?? ""))
                        }
                        else
                        {
                            self.alert(msgs:"Unable to update now")
                        }
                        
                        self.viewPopUPExpand.isHidden = true
                        self.lblPopupBG.isHidden = true
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
}

