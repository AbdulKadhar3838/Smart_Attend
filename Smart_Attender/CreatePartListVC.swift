//
//  CreatePartListVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 14/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class CreatePartListVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtPartNo: UITextField!
    
    
    @IBOutlet weak var txtDecription: UITextField!
    @IBOutlet weak var txtCycle: UITextField!
    @IBOutlet weak var txtCavity: UITextField!
    @IBOutlet weak var txtGroupID: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnLogoBuffer: UIButton!
    @IBOutlet weak var scrollParent: UIScrollView!
    var passPartNo = ""
    var passGroupID = ""
    var passCavity = ""
    var passCycleTime = ""
    var passDescription = ""
    var passTitle = ""
    var passPartID:Int64 = 0
    var isAddPart:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        callingViewDidload()
    }
    
    
    // MARK: - Local Actions
    func callingViewDidload() {
        
        self.title = passTitle
        
        let logoBtn = UIButton(type: .system)
        logoBtn.setImage(#imageLiteral(resourceName: "Dashboard"), for: .normal)
        logoBtn.addTarget(self, action: #selector(self.logoClicked(_:)) , for: .touchUpInside)
        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        logoBtn.imageView?.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoBtn)
        
        
        
        for case let textField as UITextField in self.view.subviews {
            self.anycolorborder(forview: textField, radius: 4,color: UIColor.lightGray)
        }
        self.anycolorborder(forview: self.btnSave, radius: 4,color: UIColor.lightGray)
        txtPartNo.text = passPartNo
        txtGroupID.text = passGroupID
        txtCavity.text = passCavity
        txtCycle.text = passCycleTime
        txtDecription.text = passDescription
        if isAddPart {
            btnSave.setTitle("Save", for: .normal)
        } else {
            btnSave.setTitle("Update", for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addDoneButtonOnKeyboard(txtfd: txtCavity, selector: #selector(doneButtonCavity))
        addDoneButtonOnKeyboard(txtfd: txtCycle, selector: #selector(doneButtonCycle))
    }
    
    @objc func logoClicked(_ sender: UIButton) {
        self.btnLogoBuffer.sendActions(for: .touchUpInside)
    }
    
    func addDoneButtonOnKeyboard(txtfd:UITextField,selector:Selector)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style:.plain, target: self, action: selector)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtfd.inputAccessoryView = doneToolbar
        
    }
    // For Dismiss n Reset All Values after API hitting
    func postApiAction() {
        for case let txtfd as UITextField in self.view.subviews {
            txtfd.text = ""
        }
        self.navigationController?.popViewController(animated: true)
    }
    
     @objc func keyboardWillShow_Hide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            var contentInset:UIEdgeInsets = self.scrollParent.contentInset
            contentInset.bottom = keyboardFrame.size.height+12
            self.scrollParent.contentInset = contentInset
        }
        else {
            self.scrollParent.contentInset=UIEdgeInsets.zero
        }
    }
    
    @objc func doneButtonCavity(sender:UITextField)
    {
        self.txtCycle.becomeFirstResponder()
    }
    @objc func doneButtonCycle(sender:UITextField)
    {
        self.txtDecription.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    @IBAction func savePartNo(_ sender: UIButton) {
        if txtPartNo.text == "" || txtPartNo.text == nil {
           alert(msgs: "Fill the Part Number")
        } else if txtCavity.text == "" || txtCavity.text == nil {
            alert(msgs: "Fill the Cavity")
        }  else if txtCavity.text == ""  {
            alert(msgs: "Fill the Cavity value greater than 0")
        } else if txtCycle.text == "" || txtCycle.text == nil {
            alert(msgs: "Fill the Cycle Time")
        } else if txtCycle.text == "0"  {
            alert(msgs: "Fill the Cycle Time greater than 0")
        } else if txtDecription.text == "" || txtDecription.text == nil {
            alert(msgs: "Fill the Description")
        } else {
            if isAddPart {
                if let partNo = txtPartNo.text,
                    let groupID = txtGroupID.text,
                    let cavity = txtCavity.text,
                    let cycleTime = txtCycle.text,
                    let decription = txtDecription.text
                     {
                let dict:NSMutableDictionary = [
                        "PartNumber": partNo,
                        "GroupID":groupID,
                        "Cavity": Int(cavity) ?? 0,
                        "CycleTime":cycleTime,
                        "CustomerID":customer_id!,
                        "Description": decription
                    ]
                    print(dict)
                    self.callingPostNewPartApi(dict: dict)
                    
                }
            } else {
                if let partNo = txtPartNo.text,
                    let groupID = txtGroupID.text,
                    let cavity = txtCavity.text,
                    let cycleTime = txtCycle.text,
                    let decription = txtDecription.text
                {
                     let cavity1 = cavity.trimmingCharacters(in: .whitespacesAndNewlines)
                    let dict:NSMutableDictionary = [
                        "PartNumber": partNo,
                        "GroupID":groupID,
                        "Cavity": Int(cavity1) as Any,
                        "CycleTime":cycleTime,
                        "CustomerID":customer_id!,
                        "PartId" :passPartID,
                        "Description": decription
                    ]
                    print(dict)
                    self.callingPostUpdatePartApi(dict: dict)
                    
            }
        }
        
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITextfieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPartNo {
           txtGroupID.becomeFirstResponder()
        } else if textField == txtGroupID {
            txtCavity.becomeFirstResponder()
        } else {
        textField.resignFirstResponder()
        }
        return true
    }
    
    
    // MARK: - New Part Post Api
    func callingPostNewPartApi(dict:NSMutableDictionary) {
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Part/SavePartNumber", jsonObj: dict , completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let msgs:String=dict.value(forKey: "Message") as? String ?? ""
                    
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict.value(forKey: "Message") as? String ?? "")
                            
                        }
                        else
                        {
                            message = "Part Added Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
                        })
                        
                    }
                    else
                    {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict.value(forKey: "Message") as? String ?? "")
                        }
                        else
                        {
                            message = "Unable to add Part Number now"
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
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

    // MARK: - update Part Post Api
    func callingPostUpdatePartApi(dict:NSMutableDictionary) {
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Part/UpdatePartNumber", jsonObj: dict , completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let msgs:String=dict.value(forKey: "Message") as? String ?? ""
                    
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict.value(forKey: "Message") as? String ?? "")
                            
                        }
                        else
                        {
                            message = "Part updated Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
                        })
                        
                    }
                    else
                    {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict.value(forKey: "Message") as? String ?? "")
                        }
                        else
                        {
                            message = "Unable to update Part Number now"
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
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
    
   
    
}
