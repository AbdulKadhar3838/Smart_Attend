//
//  PartAssignVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/10/17.	
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PartAssignListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var tablePartsAssign: UITableView!
    
    
    //   @IBOutlet weak var headerView: UIView!
    var selectedIndex:Int!
    var partAssignModel = PartAssignModel()
    var isFirstTimeLoaded:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tablePartsAssign.isHidden = true
        // Do any additional setup after loading the view.
        callingViewDidload()
        
        let logoBtn = UIButton(type: UIButton.ButtonType.custom)

        logoBtn.setImage(UIImage(named: "Dashboard"), for: .normal)
        logoBtn.addTarget(self, action: #selector(self.logoClicked) , for: .touchUpInside)
        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablePartsAssign.isHidden = true
        partListApi()
        selectedIndex = nil
        isFirstTimeLoaded = true
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.tablePartsAssign.layoutIfNeeded()
            self.tablePartsAssign.reloadData()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Local Functions
    func callingViewDidload() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        toSetNavigationImagenTitle(titleString:"Schedule", isHamMenu: true)
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        tablePartsAssign.delegate = self
        tablePartsAssign.dataSource = self
        tablePartsAssign.tableFooterView = UIView(frame: CGRect.zero)
        tablePartsAssign.separatorInset = UIEdgeInsets.zero
        tablePartsAssign.layoutMargins = UIEdgeInsets.zero
        
        
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        
    }
    
    func animateTableview() {
        let cells = tablePartsAssign.visibleCells
        let tableHeight:CGFloat = tablePartsAssign.bounds.size.height
        
        for i in cells {
            let cell:UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
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
    // For Remove n Reset All Values after API hitting
    func postApiAction() {
        print("post API Action")
        selectedIndex = nil
        self.partListApi()
    }
    
    
    
    // MARK: - GetAll DeviceList Method
    func partListApi()
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/PartList/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    if (success)
                    {
                        self.partAssignModel.arrayAssignedList?.removeAll()
                        self.partAssignModel =  PartAssignModel.valueInitialization(jsonData: dict)
                        
                        if let array = self.partAssignModel.arrayAssignedList{
                            if array.count > 0 {
                                
                                
                                
                                self.tablePartsAssign.isHidden = false
                                self.tablePartsAssign.reloadData()
                                if self.isFirstTimeLoaded {
                                    self.isFirstTimeLoaded = false
                                    self.animateTableview()
                                }
                                
                                
                                
                            } else {
                                self.tablePartsAssign.isHidden = true
                                self.showNodata(msgs: "Oops! There is no data in Schedule")
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
    
    func partRemoveApi(ID:Int64)
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/RemovePart/\(ID)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    var msgs:String = dict["Message"] as? String ?? ""
                    if (success)
                    {
                        
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict["Message"] as? String ?? "")
                            
                        }
                        else
                        {
                            message = "Part Removed Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
                        })
                        
                    } else {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = dict["Message"] as? String ?? ""
                        }
                        else
                        {
                            message = "Unable to remove now"
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            
                        })
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
        
    }
    
    func partResetApi(ID:Int64,subPath:String)
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/\(subPath)/\(ID)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    var msgs:String = dict["Message"] as? String ?? ""
                    if (success)
                    {
                        
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict["Message"] as? String ?? "")
                            
                        }
                        else
                        {
                            message = "Part Reset Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
                        })
                        
                    } else {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = dict["Message"] as? String ?? ""
                        }
                        else
                        {
                            message = "Unable to Reset now"
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            
                        })
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        print("More Action  & \(sender.tag)")
        
        guard let cell = sender.superview?.superview?.superview as? PartsListTableCell
            else
        {
            print("Cell not found")
            return
        }
        if cell.viewAction.isHidden {
            selectedIndex = tablePartsAssign.indexPath(for: cell)?.row
        } else {
            selectedIndex = nil
        }
        
        
        self.tablePartsAssign.reloadData()
        
        
    }
    
    @IBAction func resetAction(_ cell: PartsListTableCell) {
        print("Reset Action")
        
        cell.viewAction.isHidden = true
        let list = partAssignModel.arrayAssignedList![cell.btnReset.tag]
        
        let alertController = UIAlertController(title: "Smart Attend", message: "Do you want to Reset Part Number?", preferredStyle:.actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Yes", style:.default)
        {
            (result : UIAlertAction) -> Void in
            
            if let id = list.id {
                self.partResetApi(ID:id, subPath: "ResetPartYes") //Yes
            }
            
            print("You pressed OK")
        }
        alertController.addAction(photoLibraryAction)
        
        let cameraAction = UIAlertAction(title: "No", style: .default)
        {
            (result : UIAlertAction) -> Void in
//            if let id = list.id {
//                self.partResetApi(ID:id, subPath: "ResetPartNo") //No
//            }
            print("You pressed No")
        }
        alertController.addAction(cameraAction)
        
        let cancelbuttonAction = UIAlertAction(title: "Cancel", style:.cancel)
        {
            (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(cancelbuttonAction)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = cell.btnReset
            popoverPresentationController.sourceRect = cell.btnReset.bounds
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
    @objc func removeAction(_ cell: PartsListTableCell) {
        
        print("Remove Action")
        cell.viewAction.isHidden = true
        
        let list = partAssignModel.arrayAssignedList![cell.btnRemove.tag]
        self.alertOkCancel(msgs: "Do you want to Remove the Part Number?", handlerCancel: {_ in
            print("NO") //NO
        }, handlerOk: {_ in
            print("Yes")
            if let id = list.id{
                self.partRemoveApi(ID:id)
            }
        })
        
    }
    @objc func assignAction(_ cell: PartsListTableCell) {
        
        
        print("Assign Action")
        
        cell.viewAction.isHidden = true
        let UpdateAssignVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAssignVC") as! UpdateAssignVC
        UpdateAssignVC.passLabelName = cell.lblDeviceName.text ?? ""
        UpdateAssignVC.passPartNo = cell.lblPartNumber.text ?? ""
        UpdateAssignVC.passCavity = cell.lblCavity.text ?? ""
        UpdateAssignVC.passCycleTime = cell.lblCycle.text ?? ""
        UpdateAssignVC.passScarp = cell.lblScarp.text ?? ""
        UpdateAssignVC.passQuantity = cell.lblReqQty.text ?? ""
        if let row = (tablePartsAssign.indexPath(for: cell))?.row {
            UpdateAssignVC.selectedIndex = row
            if let partAssign = partAssignModel.arrayAssignedList?[row] {
                UpdateAssignVC.arrayAssignedList = partAssign
                UpdateAssignVC.partID = "\(partAssign.partId ?? 0)"
                
                print(UpdateAssignVC.arrayAssignedList)
            }
        }
        if let assignList = partAssignModel.arrayAssignedList {
            let referenceArray = assignList.map({$0.partNumber ?? ""})
            UpdateAssignVC.arrayPassRefPartNO = referenceArray.filter({$0 != ""})
        }
        UpdateAssignVC.istransitFromNotification = false
        self.navigationController?.pushViewController(UpdateAssignVC, animated: true)
        
    }
    
    // MARK: - Tableview Protocol methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let array =  partAssignModel.arrayAssignedList {
            return array.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PartsListTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PartsListTableCell
        
        cell.lblDeviceName.text = ""
        cell.lblCavity.text = "0"
        cell.lblCycle.text = "0"
        cell.lblStartDate.text = ""
        cell.lblReqQty.text = "0"
        cell.lblPartNumber.text = ""
        cell.lblStartDate.text = ""
        
        
        
        if let assignList = partAssignModel.arrayAssignedList {
            let list = assignList[indexPath.row]
            
            if let deviceName = list.deviceName {
                cell.lblDeviceName.text = deviceName
            }
            if let cavity = list.cavity {
                cell.lblCavity.text = "\(cavity)"
            }
            if let  cycle = list.cycleTime {
                cell.lblCycle.text = cycle
            }
            if let  scrap = list.scrap {
                cell.lblScarp.text = "\(scrap)"
            }
            if let  startDate = list.startDate ,startDate  != ""{
                let stringValue = startDate.replacingOccurrences(of: "T", with: " ")
                //  cell.lblStartDate.text = stringValue
                let attribString = NSMutableAttributedString(string: stringValue)
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.minimumLineHeight = 13
                attribString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: stringValue.characters.count))
                cell.lblStartDate.attributedText = attribString
                
                
                
            }
            if let required = list.requiredQuantity {
                cell.lblReqQty.text = "\(required)"
                cell.lblReqQty.adjustsFontSizeToFitWidth = true
            }
            
            if let partNO = list.partNumber {
                print(partNO)
                cell.lblPartNumber.text = partNO
            }
        }
        cell.btnRemove.tag = indexPath.row
        cell.btnReset.tag = indexPath.row
        
        
        cell.btnAssign.addTarget(self, action: #selector(self.assignAction(_:)), for: UIControlEvents.touchUpInside)
        cell.btnRemove.addTarget(self, action: #selector(self.removeAction(_:)), for: UIControlEvents.touchUpInside)
        
        cell.btnAssign.layer.cornerRadius = 4
        cell.btnRemove.layer.cornerRadius = 4
        cell.btnReset.layer.cornerRadius = 4
        cell.btnAction.tag = indexPath.row
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.init(netHex: 0xF1F1F1)
        }
        
        
        for pklayer in cell.viewAction.layer.sublayers!
        {
            if pklayer.name == "peeker"
            {
                print("Peek already added in it")
                pklayer.removeFromSuperlayer()
            }
        }
        
        cell.viewAction.isHidden = true
        if selectedIndex != nil && selectedIndex == indexPath.row
        {
            cell.viewAction.addPikeOnView(side: .Right, size: 0.5 * cell.viewAction.frame.height)
            cell.viewAction.layoutIfNeeded()
            cell.viewAction.isHidden = false
        }
        
        //Frame Update During Orientation
        cell.viewAction.dropShadow()
        
        
        
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("Did Select")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell2")
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(editingStyle.rawValue)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! PartsListTableCell
        
        let edit = UITableViewRowAction(style: .normal, title: "Assign/Edit") { (action, indexPath) in
            // Edit item at indexPath
            self.assignAction(cell)
        }
        
//        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
//            // Remove item at indexPath
//            print("remove part")
//            self.removeAction(cell)
//
//        }
//
        
        
        let reset = UITableViewRowAction(style: .normal, title: "Reset") { (action, indexPath) in
            // Reset item at indexPath
            self.resetAction(cell)
            
        }
        reset.backgroundColor = UIColor.init(netHex_String: "#9b59b6")
       // remove.backgroundColor = UIColor.init(netHex_String: "#e74c3c")
        edit.backgroundColor = UIColor.init(netHex_String: "#e67e22")
        return [reset, edit]
      //  return [reset,remove, edit]
        
    }
}


