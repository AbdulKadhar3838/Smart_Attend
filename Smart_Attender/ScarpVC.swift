//
//  ScarpVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 21/11/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import UIKit


class ScarpVC: UIViewController {
    // MARK: - Initialization
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var constraintBotomFooter: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tblScarp: UITableView!
    var deviceId = ""
    var dictPost:[NSMutableDictionary] = []
    var arrayScarpList:[ScarpResponseList] = [] {
        didSet {
            arraytextfield.removeAll()
            for _ in 0..<arrayScarpList.count {
                arraytextfield.append("0")
            }
            
            //calculateFooterHeight()
            tblScarp.reloadData()
            footerView.isHidden = false
        }
    }
    
    var arraytextfield:[String] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        partListApi()
        zoomIN()
    }
    
   
    
    override func viewDidLayoutSubviews() {
        //calculateFooterHeight()
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
    // MARK: - Local Methods
    func initView() {
        self.title = "Add Scarp "
        tblScarp.tableFooterView = UIView(frame: CGRect.zero)
        footerView.isHidden = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.close(_:)))
        self.view.addGestureRecognizer(tapGes)
        
    }
    
    func calculateFooterHeight() {
        let tblCellHeight:CGFloat = (40 * CGFloat(arrayScarpList.count) + tblScarp.frame.origin.y)
        let diff:CGFloat =   self.view.frame.height - 40 - tblCellHeight
        if diff > 0.0 {
            constraintBotomFooter.constant = diff
        }
        
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

        self.removeChildVC(child: self)
    }
    
    func addDoneButtonOnKeyboard(txtfd:UITextField,selector:Selector)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Add", style:.plain, target: self, action: selector)
        
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

extension ScarpVC :UITableViewDelegate,UITableViewDataSource{
    // MARK: - Tableview Delegate and  Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayScarpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScarpTableCell", for: indexPath) as! ScarpTableCell
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let list = arrayScarpList[indexPath.row]
        cell.lblPartNo.text = list.PartNumber
        cell.lblAccumulate.text = list.ScrapCount
        
        cell.txtQuantity.delegate = self
        
        if arraytextfield.count == arrayScarpList.count && arraytextfield.count  > 0 {
            
            cell.txtQuantity.text = arraytextfield[indexPath.row]
        }
        cell.txtQuantity.tag = indexPath.row
        addDoneButtonOnKeyboard(txtfd: cell.txtQuantity, selector: #selector(self.doneButtonScarp(sender:)))
        
        return cell
    }
    
    
}

extension ScarpVC :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if arraytextfield.count > 0 {
            arraytextfield[textField.tag] = textField.text ?? "0"
            btnSave.isEnabled = true
            btnSave.alpha = 1
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        btnSave.isEnabled = false
        btnSave.alpha = 0.5
    }
    
}

extension ScarpVC {
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

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
