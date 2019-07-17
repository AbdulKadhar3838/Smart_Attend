//
//  PopupViewController.swift
//  Mtopo_Merchant
//
//  Created by CIPL-258-MOBILITY on 18/11/16.
//  Copyright © 2016 Peer Mohamed Thabib. All rights reserved.
//

import UIKit
import AVFoundation

let url_path = Bundle.main.url(forResource: "music", withExtension: "mp3")!
class MachineDetails_ViewController: UIViewController  {
    // MARK: - Connected Outlets
    
    @IBOutlet weak var constraintTxtVWHeight: NSLayoutConstraint!
    @IBOutlet weak var close_butn: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var tableExpand: UITableView!
    @IBOutlet weak var txtvwDescription: UITextView!
    
    
    var audio_player:AVAudioPlayer!
    @IBOutlet weak var popup_view: UIView!
    @IBOutlet weak var viewOkBG: UIView!
    @IBOutlet weak var popup_yvalue: NSLayoutConstraint!
    
    @IBOutlet weak var outer_label: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    
    // MARK: - Variables
    var data_dict: NSDictionary=[:]
    var checkbox_value: Int=0
    var subCheckboxValue: Int64=0
    
    var portraitHeight:CGFloat = 0
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
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.popup_yvalue.constant=self.view.frame.size.height
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
        
        //self.btnOK.layer.cornerRadius = 4
        self.title_label.text=data_dict.value(forKey: "DeviceName") as? String
        self.self.status_label.text = data_dict.value(forKey: "InputName") as? String ?? ""
        
        
//        let status:NSNumber=data_dict.value(forKey: "RunningStatus") as! NSNumber
//        if let actionof = Global.machine_status(rawValue: Int(status))
//        {
//          //  self.status_label.text =  actionof.stringvalue
//            //self.status_label.textColor = actionof.color
//        }
        settingTextviewDatanSize(textview: txtvwDescription)
        
        let IsShutdown:NSNumber=data_dict.value(forKey: "IsShutdown") as? NSNumber ?? 0
        if IsShutdown == 1
        {
            // Need to Show all 3 Checkbox
            actualSectionNo = 3
        }
        else
        {
            // Need to hide 2 Checkbox
            actualSectionNo = 1
        }
        
        if let id = data_dict.value(forKey: "DeviceID") as? Int64 {
            
            if isFirstTimePopExpand {
                notificationListApi(deviceID:id)
            } else {
                self.tableExpand.isHidden = false
            }
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animate_view(initial: self.view.frame.size.height, final: 0)
      //  self.anycolorborder(forview: self.close_butn, radius: 6, color: UIColor.yellow)
        toSetTabelContentHeight(table: tableExpand)
        popup_view.layer.cornerRadius = 6
        popup_view.layer.masksToBounds = true
        viewOkBG.layer.cornerRadius = 6
        viewOkBG.layer.masksToBounds = true
        btnOK.layer.cornerRadius = 6
        btnOK.layer.masksToBounds = true
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.dismissKeyboard()
    }
    func outer_labelTapped() {
        self.Close_click( sender: nil )
    }
    
    // MARK: - Button Actions
    @IBAction func Close_click(sender: AnyObject?) {
        emptyExpandTableview()
        for i in 0..<self.selectedPlanned.count {
            self.selectedPlanned[i] = false
        }
        for i in 0..<self.selectedUnPlanned.count {
            self.selectedUnPlanned[i] = false
        }
        self.popup_yvalue.constant=0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.74, delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0, options: [], animations: {
            self.popup_yvalue.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
            self.view.alpha=0
            NotificationCenter.default.post(name: .Popup_Closed, object: self, userInfo: nil)
        }, completion:
            { completed in
                if(completed){
                    self.view.removeFromSuperview()
                    dfualts.setValue(true, forKey: "r eload")
                }
        })
    }
    
    
    
    
    // MARK: - Local Functions
    func changeOverAlertShowing() {
        let alertController = UIAlertController(title: "Smart Attend", message: "Successfully Applied. Do you want to assign part number? ", preferredStyle: .alert)
        
        let YesAction = UIAlertAction(title: "Yes", style:.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
            
            let UpdateAssignVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateAssignVC") as! UpdateAssignVC
            UpdateAssignVC.passLabelName = self.title_label.text ?? ""
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
            popoverPresentationController.sourceView =  self.status_label
            popoverPresentationController.sourceRect = self.status_label.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func post_settings() {
        self.startloader(msg: "Loading.... ")
        if subCheckboxValue == 0 {
            if (checkbox_value == 2) {
                subCheckboxValue =  arrayPlannedID[0]
            }
            if  checkbox_value == 3 {
                subCheckboxValue =  arrayUnplannedID[0]
            }
        }
        
        let postdict:NSMutableDictionary=["InputID": data_dict.value(forKey: "InputID") as? NSNumber ?? 0,
                                          "InputNotification": checkbox_value != 1 ? 0 : 1,
                                          "MachineShutdown": checkbox_value != 2 ? 0 : 2,
                                          "MachineDowntime": checkbox_value != 3 ? 0: 3 ,
                                          "Description": subCheckboxValue != 0 ? subCheckboxValue: 0,
                                          "OtherDowntime": otherDowntime,
                                           "OtherShutdown":otherShutdown,
                                          "DeviceID": data_dict.value(forKey: "DeviceID") as? NSNumber ?? 0,
                                          "AccountID": data_dict.value(forKey: "AccountID") as? NSNumber ?? 0,
                                          "InputName": data_dict.value(forKey: "InputName") as? String ?? ""]
        Global.server.Post(path: "Dashboard/NotificationOff", jsonObj: postdict, completionHandler: {
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
                            if(msgs.count>0)
                            {
                                self.alert(msgs: (dict.value(forKey: "Message") as? String ?? ""))
                            }
                            else
                            {
                                self.alert(msgs:"Updated Succesfully")
                            }
                        }
                        self.Close_click(sender: nil)
                    }
                    else
                    {
                        if(msgs.count>0)
                        {
                            self.alert(msgs: (dict.value(forKey: "Message") as? String ?? ""))
                        }
                        else
                        {
                            self.alert(msgs:"Unable to update now")
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
    
    func settingTextviewDatanSize(textview:UITextView) {
        textview.text = data_dict.value(forKey: "Description") as? String
        textview.isEditable = false
        
        var thresholdHeight:CGFloat = 0
        if Global.IS.IPAD || Global.IS.IPAD_PRO {
            thresholdHeight = 120
        } else {
            thresholdHeight = 70
        }
        
        if textview.contentSize.height < thresholdHeight
        {
            constraintTxtVWHeight.constant = textview.contentSize.height
            textview.isScrollEnabled = false
            
        } else {
            constraintTxtVWHeight.constant = thresholdHeight
            textview.isScrollEnabled = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animate_view(initial:CGFloat,final:CGFloat)
    {
//        do {
//            let sound = try AVAudioPlayer(contentsOf: url_path)
//            audio_player = sound
//            sound.play()
//        } catch {
//            // couldn't load file :(
//        }
        
        self.popup_yvalue.constant=initial
        self.popup_view.isHidden = false
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0, options: [], animations: {
            self.popup_yvalue.constant=final
            self.view.layoutIfNeeded()
        }, completion: { completed in
            if(completed){
//                if self.audio_player != nil {
//                    self.audio_player.stop()
//                    self.audio_player = nil
//                }
            }})
    }
    
    
}
extension MachineDetails_ViewController:UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{
    
    
    @IBAction func okBtnForPost(_ sender: UIButton) {
        post_settings()
    }
    
    func emptyExpandTableview() {
        let cells = tableExpand.visibleCells
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
    
    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        otherDowntime = ""
        otherShutdown = ""
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let diffHeight = (self.view.frame.size.height - keyboardHeight) - self.popup_view.frame.size.height
            
            popExpandHeight = self.popup_view.frame.origin.y
            UIView.animate(withDuration: 0.3,
                           animations: {
                            
                            self.popup_view.frame.origin.y = diffHeight + self.btnOK.frame.size.height
            },
                           completion: nil)
            
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        
                        self.popup_view.frame.origin.y = self.popExpandHeight
        },
                       completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isOtherDowntime {
            otherDowntime = textField.text ?? ""
        }
        if isOtherShutdown {
            otherShutdown = textField.text ?? ""
        }
    }
    
    
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
                                    
                                    self.tableExpand.isHidden = false
                                    self.toLoadExpandCollapse()
                                } else {
                                    self.tableExpand.isHidden = true
                                    //Need to add OK btn to hidden
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
    
    func toLoadExpandCollapse() {
        if let array = notificationListModel.arrayList{
            if let arrayEntity:[Int] = array.map({$0.entityType}) as? [Int] {
                if let description = array.map({$0.description}) as? [String],let masterID:[Int64] = array.map({$0.plannedShutdownMasterID}) as? [Int64], let id = array.map({$0.id}) as? [Int64] {
                    isFirstTimePopExpand = false
                    selectedPlanned.removeAll()
                    selectedUnPlanned.removeAll()
                    for i in 0..<arrayEntity.count {
                        if arrayEntity[i] == 1 {
                            selectedPlanned.append(false)
                            arrayPlannedID.append(id[i])
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
    
    // MARK: - Local Functions
    //Inside Section (Subcheck box) tapping
    @objc func insideCheckBoxTapping(sender: UIButton) {
        print(sender.tag)
        subCheckboxValue = 0
        isChangeOver = false
        isOtherDowntime = false
        isOtherShutdown = false
        otherDowntime = ""
        otherShutdown = ""
        otherCellHeight = 30
        sender.isSelected = !sender.isSelected
        
        if let cell = sender.superview?.superview as? ExpandCollapseCell {
            cell.btnCheckBox.isSelected =  !cell.btnCheckBox.isSelected
            cell.txtField.isHidden = true
            self.dismissKeyboard()
            self.popup_view.transform = CGAffineTransform.identity
            
            
            if sender.isSelected {
                if checkbox_value == 2 {
                    selectedPlanned[sender.tag] = true
                }
                if checkbox_value == 3 {
                    selectedUnPlanned[sender.tag] = true
                }
                
                if let indexpath = tableExpand.indexPath(for: cell) {
                    if indexpath.section == 2 {
                        
                        for i in 0..<arrayUnplannedData.count where i != sender.tag{
                            let indexpath:IndexPath = IndexPath.init(row: i, section: 2)
                            let cell = self.tableExpand.cellForRow(at: indexpath) as? ExpandCollapseCell
                            cell?.btnText.isSelected = !sender.isSelected
                            cell?.btnCheckBox.isSelected = !sender.isSelected
                            cell?.txtField.isHidden = true
                            selectedUnPlanned[i] = false
                        }
                        isOtherDowntime = false
                        if cell.lblCheckbox.text == "Other" {
                            cell.txtField.isHidden = false
                            cell.txtField.text = ""
                            
                            //cell.txtField.becomeFirstResponder()
                            isOtherDowntime = true
                            tableExpand.beginUpdates()
                            otherCellHeight = 70
                            
                            tableExpand.reloadRows(at: [indexpath], with: .none)
                            tableExpand.endUpdates()
                            
                            
                        }
                        subCheckboxValue = arrayUnplannedID[sender.tag]
                        
                        
                    } else {
                        
                        for i in 0..<arrayPlannedData.count where i != sender.tag{
                            let indexpath:IndexPath = IndexPath.init(row: i, section: 1)
                            let cell = self.tableExpand.cellForRow(at: indexpath) as? ExpandCollapseCell
                            cell?.btnCheckBox.isSelected = !sender.isSelected
                            cell?.btnText.isSelected = !sender.isSelected
                            cell?.txtField.isHidden = true
                            selectedPlanned[i] = false
                            
                        }
                        subCheckboxValue = arrayPlannedID[sender.tag]
                        isOtherShutdown = false
                        if cell.lblCheckbox.text == "Other" {
                            cell.txtField.isHidden = false
                            cell.txtField.text = ""
                            
                           // cell.txtField.becomeFirstResponder()
                            isOtherShutdown = true
                            tableExpand.beginUpdates()
                            otherCellHeight = 70
                            tableExpand.reloadRows(at: [indexpath], with: .none)
                            tableExpand.endUpdates()
                            
                            
                        }
                        if let changeOVer = cell.lblCheckbox.text {
                            if changeOVer.contains(self.changeOverSpelling) {
                                isChangeOver = true
                            }
                        }
                    }
                }
            } else {
                if checkbox_value == 2 {
                    selectedPlanned[sender.tag] = false
                }
                if checkbox_value == 3 {
                    selectedUnPlanned[sender.tag] = false
                }
                if let indexpath = tableExpand.indexPath(for: cell) {
                    if cell.lblCheckbox.text == "Other"
                    {
                        tableExpand.beginUpdates()
                        otherCellHeight = 30
                        tableExpand.reloadRows(at: [indexpath], with: .none)
                        tableExpand.endUpdates()
                    }
                }
                
            }
        }
    }
    
    
    //Section Tapping
    @objc func expandCollapse(sender: UIButton) {
        checkbox_value = 0
        otherCellHeight = 30
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedSection = sender.tag
            tableExpand.reloadData()
            tableExpand.beginUpdates()
            if sender.tag == 1 {
                
                for i in 0..<selectedUnPlanned.count {
                    selectedUnPlanned[i] = false
                }
                for i in 0..<selectedPlanned.count {
                    selectedPlanned[i] = false
                }
                checkbox_value = 2
                
                if tableExpand.numberOfRows(inSection: sender.tag) != arrayPlannedData.count {
                    rowsInSectionOne = arrayPlannedData.count
                    var indexpath:[IndexPath] = []
                    for i in 0..<arrayPlannedData.count {
                        indexpath.append(IndexPath.init(row: i, section: 1))
                    }
                    tableExpand.insertRows(at: indexpath, with: .none)
                }
                
                collapseSectionTwo()
                
            } else if sender.tag == 2 {
                for i in 0..<selectedUnPlanned.count {
                    selectedUnPlanned[i] = false
                }
                for i in 0..<selectedPlanned.count {
                    selectedPlanned[i] = false
                }
                
                checkbox_value = 3
                rowsInSectionTwo = arrayUnplannedData.count
                if tableExpand.numberOfRows(inSection: sender.tag) != arrayUnplannedData.count {
                    var indexpath:[IndexPath] = []
                    for i in 0..<arrayUnplannedData.count {
                        indexpath.append(IndexPath.init(row: i, section: 2))
                    }
                    tableExpand.insertRows(at: indexpath, with: .none)
                }
                
                collapseSectionOne()
                
            } else {
                checkbox_value = 1
                collapseSectionOne()
                collapseSectionTwo()
                
            }
            tableExpand.endUpdates()
        } else {
            selectedSection = noOfSection + 1
            tableExpand.reloadData()
            tableExpand.beginUpdates()
            collapseSectionOne()
            collapseSectionTwo()
            tableExpand.endUpdates()
            
        }
        tableExpand.layoutIfNeeded()
        toSetTabelContentHeight(table:tableExpand)
    }
    
    func collapseSectionOne(){
        if tableExpand.numberOfRows(inSection: 1) == arrayPlannedData.count {
            rowsInSectionOne = 0
            var indexpath:[IndexPath] = []
            for i in 0..<arrayPlannedData.count {
                indexpath.append(IndexPath.init(row: i, section: 1))
            }
            tableExpand.deleteRows(at: indexpath, with: .none)
        }
    }
    func collapseSectionTwo(){
        if tableExpand.numberOfRows(inSection: 2) == arrayUnplannedData.count {
            rowsInSectionTwo = 0
            var indexpath:[IndexPath] = []
            for i in 0..<arrayUnplannedData.count {
                indexpath.append(IndexPath.init(row: i, section: 2))
            }
            tableExpand.deleteRows(at: indexpath, with: .none)
        }
    }
    
    func toSetTabelContentHeight(table:UITableView) {
        tableExpand.tableFooterView = UIView(frame: .zero)
        let totalHeight:CGFloat = table.contentSize.height + txtvwDescription.frame.height+btnOK.frame.size.height  + 20 + topView.frame.size.height
        
        if  totalHeight <= popup_view.frame.size.height{
            constraintHeightTable.constant = table.contentSize.height
        } else {
            constraintHeightTable.constant = popup_view.frame.size.height - (txtvwDescription.frame.height+btnOK.frame.size.height  + 20 + topView.frame.size.height )
        }
        
    }
    
    // MARK: - Tableiew Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return rowsInSectionOne
            
        } else {
            return rowsInSectionTwo
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExpandCollapseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpandCollapseCell
        
        cell.txtField.isHidden = true
        cell.txtField.layer.borderWidth = 1
        self.anycolorborder(forview: cell.txtField, radius: 4,color: UIColor.darkGray)
                cell.lblCheckbox.text = ""
        
        cell.btnText.addTarget(self, action: #selector(insideCheckBoxTapping), for: .touchUpInside)
        cell.btnCheckBox.isSelected = false
        
        
        if indexPath.section == 1 {
            cell.lblCheckbox.text = self.arrayPlannedData[indexPath.row]
            cell.btnCheckBox.tag = indexPath.row
            cell.btnText.tag = indexPath.row
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
            
            otherShutdown = cell.txtField.text ?? ""
            
            cell.btnCheckBox.isSelected = selectedPlanned[indexPath.row]
            cell.btnText.isSelected = selectedPlanned[indexPath.row]
            
            if let row =  arrayPlannedData.index(of: "Other") ,row ==  indexPath.row{
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
        if indexPath.section == 2 {
            
            cell.lblCheckbox.text = self.arrayUnplannedData[indexPath.row]
            cell.btnCheckBox.tag = indexPath.row
            cell.btnText.tag = indexPath.row
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
            cell.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
            otherDowntime = cell.txtField.text ?? ""
            
            cell.btnCheckBox.isSelected = selectedUnPlanned[indexPath.row]
            cell.btnText.isSelected = selectedUnPlanned[indexPath.row]
            
            if let row =  arrayUnplannedData.index(of: "Other") ,row ==  indexPath.row{
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actualSectionNo
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
                let row =  arrayPlannedData.index(of: "Other")
                if row == indexPath.row {
                    return otherCellHeight//70
                }
            }
            if indexPath.section == 2 {
                let row =  arrayUnplannedData.index(of:"Other" )
                if row == indexPath.row {
                    return otherCellHeight//70
                }
            }
            return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            // No Error Notification
            let header = tableView.dequeueReusableCell(withIdentifier: "ExpandHeaderCell")! as! ExpandHeaderCell
            header.lblCheckbox.text = "No error notification for this event"
            header.btnText.tag = section
            header.btnText.addTarget(self, action: #selector(expandCollapse), for: .touchUpInside)
            header.btnCheckBox.isSelected = false
            header.btnText.isSelected = false
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
            
            if selectedSection == section {
                header.btnCheckBox.isSelected = true
                header.btnText.isSelected = true
            }
            
            if Global.IS.IPAD || Global.IS.IPAD_PRO {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 22)
            } else {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 12)
            }
            
            return header.contentView
            
        } else if section == 1 {
            // Planned Shutdown
            let header = tableView.dequeueReusableCell(withIdentifier: "ExpandHeaderCell")! as! ExpandHeaderCell
            header.lblCheckbox.text = "Planned machine shutdown"
            header.btnText.tag = section
            header.btnText.addTarget(self, action: #selector(expandCollapse), for: .touchUpInside)
            header.btnCheckBox.isSelected = false
            header.btnText.isSelected = false
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
            
            if selectedSection == section {
                header.btnCheckBox.isSelected = true
                header.btnText.isSelected = true
            }
            if Global.IS.IPAD || Global.IS.IPAD_PRO {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 22)
            } else {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 12)
            }
            return header.contentView
            
        } else {
            // UnPlanned Shutdown
            let header = tableView.dequeueReusableCell(withIdentifier: "ExpandHeaderCell")! as! ExpandHeaderCell
            header.lblCheckbox.text = "Unplanned machine shutdown"
            header.btnText.tag = section
            header.btnText.addTarget(self, action: #selector(expandCollapse), for: .touchUpInside)
            header.btnCheckBox.isSelected = false
            header.btnText.isSelected = false
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_ticked"), for: .selected)
            header.btnCheckBox.setImage(#imageLiteral(resourceName: "Checkbox_tick empty"), for: .normal)
            
            if selectedSection == section {
                header.btnCheckBox.isSelected = true
                header.btnText.isSelected = true
            }
            
            if Global.IS.IPAD || Global.IS.IPAD_PRO {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 22)
            } else {
                header.lblCheckbox.font = UIFont.systemFont(ofSize: 12)
            }
            return header.contentView
        }
    }
    
}

