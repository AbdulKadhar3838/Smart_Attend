//
//  ScarpVC1.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 04/12/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ScarpVC1: UIViewController {
    // MARK: - Initialization
    @IBOutlet weak var lblScrapAcc: UILabel!
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var tblScarp: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var txtScrapEnter: UITextField!
    @IBOutlet weak var viewTxtfd: UIView!
    var deviceId = ""
    var dictPost:[NSMutableDictionary] = []
    var arraytextfield:[String] = []
    var selectedIndex = 0 {
        didSet {
            if arrayScarpList.count > 0 {
                lblScrapAcc.text = arrayScarpList[selectedIndex].ScrapCount
                
            }
        }
    }
    var arrayScarpList:[ScarpResponseList] = [] {
        didSet {
            arraytextfield.removeAll()
            for _ in 0..<arrayScarpList.count {
                arraytextfield.append("0")
            }
            
            //calculateFooterHeight()
            if arrayScarpList.count > 0 {
                lblScrapAcc.text = arrayScarpList[0].ScrapCount
            }
            
            tblScarp.reloadData()
            footerView.isHidden = false
            viewTxtfd.isHidden = false
            self.txtScrapEnter.becomeFirstResponder()
            
            
            if  (Global.IS.IPAD || Global.IS.IPAD_PRO) {
                txtScrapEnter.keyboardDistanceFromTextField = 93
            } else {
                txtScrapEnter.keyboardDistanceFromTextField = 73
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        zoomIN()
        partListApi()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        constraintHeightTable.constant =  CGFloat(30 + arrayScarpList.count * 40)
    }
    
   override func viewDidAppear(_ animated: Bool) {
        txtScrapEnter.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    @IBAction func save(_ sender: Any) {
        print("save")
        if let dict = formDict() {
            self.callingPost(dictPost: dict)
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        print("close")
        postApiAction()
    }
    
    @IBAction func partNoSelection(_ sender: UIButton) {
        guard let cell = sender.superview?.superview     as? ScarpCell  else { return }
        selectedIndex = sender.tag
       txtScrapEnter.text = arraytextfield[sender.tag]
        cell.btnPartNo.backgroundColor = UIColor.init(netHex: 0x459E87)
        
      
        
        cell.btnPartNo.setTitleColor(UIColor.white, for: .normal)
        cell.btnPartNo.layer.borderColor = cell.btnPartNo.backgroundColor?.cgColor
       // tblScarp.reloadData()
        
        for i in 0..<arrayScarpList.count where i != sender.tag{
            let indexpath = IndexPath(row: i, section: 0)
            let cellRemaining = tblScarp.cellForRow(at: indexpath) as! ScarpCell
             cellRemaining.btnPartNo.backgroundColor = UIColor.init(netHex: 0xEAEAEA)
            cellRemaining.btnPartNo.setTitleColor(UIColor.init(netHex: 0x969494), for: .normal)
            cellRemaining.btnPartNo.layer.borderColor = cellRemaining.btnPartNo.backgroundColor?.cgColor
        }
        
    }
    
    // MARK: - Local Actions
    func initView() {
        txtScrapEnter.text = ""
        tblScarp.tableFooterView = UIView(frame: CGRect.zero)
        footerView.isHidden = true
        viewTxtfd.isHidden = true
        addDoneButtonOnKeyboard(txtfd: txtScrapEnter, selector: #selector(self.doneButtonScarp(sender:)))
        
    }
    
    fileprivate func zoomIN() {
        viewPopup.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            self?.viewPopup.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    // For Dismiss n Reset All Values after API hitting
    func postApiAction() {
        arraytextfield.removeAll()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addDoneButtonOnKeyboard(txtfd:UITextField,selector:Selector)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style:.plain, target: self, action: selector)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtfd.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonScarp(sender:UITextField)
    {
        view.endEditing(true)
        
    }
    
    func formDict() -> [NSMutableDictionary]? {
        var arrayDict:[NSMutableDictionary] = []
        for i in 0..<arraytextfield.count {
            let dict:NSMutableDictionary = [
                "PartId":arrayScarpList[i].PartId,
                "DeviceID":deviceId,
                "ScrapCount": arraytextfield[i] == "" ? "0" : arraytextfield[i] ,
                "StartDateTime": ""
            ]
            arrayDict.append(dict)
        }
        return arrayDict
    }
    
    func postFailure() {
        arraytextfield.removeAll()
        for _ in 0..<arrayScarpList.count {
            arraytextfield.append("0")
        }
        tblScarp.reloadData()
    }
    
}

extension ScarpVC1 :UITableViewDelegate,UITableViewDataSource{
    // MARK: - Tableview Delegate and  Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayScarpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScarpCell", for: indexPath) as! ScarpCell
        cell.btnPartNo.backgroundColor = UIColor.lightGray
        cell.btnPartNo.addTarget(self, action: #selector(self.partNoSelection(_:)), for: .touchUpInside)
        let list = arrayScarpList[indexPath.row]
        cell.btnPartNo.setTitle(list.PartNumber, for: .normal)
        print(list.Description)
       
        
        cell.btnPartNo.tag = indexPath.row
        
        if indexPath.row == selectedIndex{
            cell.btnPartNo.backgroundColor = UIColor.init(netHex: 0x459E87)  //5AB4E9 55C0A2
            cell.btnPartNo.setTitleColor(UIColor.white, for: .normal)
        } else {
            cell.btnPartNo.backgroundColor = UIColor.init(netHex: 0xEAEAEA)
            cell.btnPartNo.setTitleColor(UIColor.init(netHex: 0x969494), for: .normal)
        }
        cell.btnPartNo.layer.borderColor = cell.btnPartNo.backgroundColor?.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  (Global.IS.IPAD || Global.IS.IPAD_PRO) {
             return 80
        } else {
             return 60
        }
        
    }
    
}

extension ScarpVC1 :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if arraytextfield.count > 0 {
            arraytextfield[selectedIndex] = textField.text ?? "0"
            btnSave.isEnabled = true
            btnSave.alpha = 1
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSave.isEnabled = false
        btnSave.alpha = 0.5
    }
    
}

extension ScarpVC1 {
    // MARK: - APi
    func partListApi()
    {
        guard let customerID = customer_id , customerID != "", deviceId != ""  else { return }
        if !ifLoading()
        {
            self.startloader(msg: "Loading.... ")
            Global.server.Get(path: "Part/ScrapDetail/\(customerID)/\(deviceId)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let dict = success as! [String : AnyObject]
                    if(dict["IsSuccess"] != nil)
                    {
                        let success = dict["IsSuccess"] as? Bool ?? false
                        
                        if (success)
                        {
                            guard let responseData = try? JSONSerialization.data(withJSONObject: dict, options: []) ,
                                let model = try? JSONDecoder().decode(ScarpResponseModel.self, from: responseData) else { return }
                            
                            
                            self.arrayScarpList.removeAll()
                            self.arrayScarpList = model.lstPart
                            
                            print(model)
                            
                            
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
    
    
    func callingPost(dictPost:[NSMutableDictionary]) {
        self.startloader(msg: "Loading.... ")
        Global.server.PostRequestArray(path: "Part/SaveScrap", jsonObj: dictPost , completionHandler: {
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
                        if(msgs.count>0)
                        {
                            
                            self.alert_handler(msgs: (dict.value(forKey: "Message") as? String ?? ""), dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        else
                        {
                            
                            self.alert_handler(msgs: "Scarp Added Succesfully", dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        
                    }
                    else
                    {
                        if(msgs.count>0)
                        {
                            self.alert_handler(msgs: (dict.value(forKey: "Message") as? String ?? ""), dismissed: {_ in
                                //self.postApiAction()
                                
                            })
                        }
                        else
                        {
                            self.alert_handler(msgs: "Unable to add scarp now", dismissed: {_ in
                                // self.postApiAction()
                            })
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
}
