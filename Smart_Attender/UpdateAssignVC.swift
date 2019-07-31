//
//  UpdateAssignVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class UpdateAssignVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    // MARK: - Initialization
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var txtAccScrap: UITextField!
    
    @IBOutlet weak var txtScarp: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtCycleTime: UITextField!
    @IBOutlet weak var txtCavity: UITextField!
    @IBOutlet weak var txtPartNumber: UITextField!
    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var constraintHeightTable: NSLayoutConstraint!
    @IBOutlet weak var scrollParent: UIScrollView!
    @IBOutlet weak var btnLogoBuffer: UIButton!
    
    
    var arrayPartNumber:[String] = []
    var arraySearchPartNumber:[String] = []
    var arrayDescriptionPartNumber:[String] = []
    var passLabelName = ""
    var passPartNo = ""
    var passCavity = ""
    var passCycleTime = ""
    var passScarp = ""
    var passQuantity = ""
    var partAssignSearchListModel = PartAssignSearchListModel()
    var arrayAssignedList = ArrayAssignedList()
    var selectedIndex:Int!
    var partID = ""
    var arrayPassRefPartNO:[String] = []
    var partAssignModel = PartAssignModel()
    var istransitFromNotification:Bool = false
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callingViewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Local Method
    func  callingViewDidLoad() {
        UpdateUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.keyboardDismiss))
        view.addGestureRecognizer(tap)
        txtPartNumber.addTarget(self, action: #selector(searchRecordAsPerText(_ :)), for: .editingChanged)
        lblDeviceName.text = passLabelName
        txtPartNumber.text = passPartNo
        txtCavity.text = passCavity
        txtQuantity.text = passQuantity
        txtCycleTime.text = passCycleTime
        txtScarp.text = "0"
        txtAccScrap.text = passScarp
        
        
        if istransitFromNotification {
            partListApi()
        }
        gettingSearchPartNOApi()
        tableSearch.layer.borderColor = UIColor.lightGray.cgColor
        tableSearch.layer.borderWidth = 1
        tableSearch.tableFooterView = UIView.init(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func  searchRecordAsPerText(_ textfield: UITextField){
        self.tableSearch.isHidden = false
        arraySearchPartNumber.removeAll()
        
        if textfield.text?.characters.count != 0 {
            var arrayCombined:[String] = []
            var arrayDescriptionTemp:[String] = []
            
            for partNumber in arrayPartNumber {
                let range  = partNumber.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    arrayCombined.append(partNumber)
                    print(partNumber)
                }
            }
            
            for partNumber in arrayDescriptionPartNumber {
                let range  = partNumber.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    arrayDescriptionTemp.append(partNumber)
                }
            }
            var arrayDescriptionIndex:[Int] = []
            for description in arrayDescriptionTemp {
                if description != "" {
                arrayDescriptionIndex.append(self.arrayDescriptionPartNumber.index(of: description)!)
                }
            }
            var arrayDescrToPartNo:[String] = []
            for partno in arrayDescriptionIndex {
                let part = arrayPartNumber[partno]
                arrayDescrToPartNo.append(part)
            }
            arraySearchPartNumber = Array(Set(arrayCombined + arrayDescrToPartNo))
            
        } else {
            arraySearchPartNumber = arrayPartNumber
        }
        self.tableSearch.reloadData()
       // tableSearch.frame = CGRect(x: tableSearch.frame.origin.x, y: tableSearch.frame.origin.y, width: tableSearch.frame.size.width, height: tableSearch.contentSize.height)
        
    }
    
    func UpdateUI() {
        self.title = "UPDATE PART ASSIGN"
        let logoBtn = UIButton(type: .system)
        logoBtn.setImage(#imageLiteral(resourceName: "Dashboard"), for: .normal)
        logoBtn.addTarget(self, action: #selector(self.logoClicked(_:)) , for: .touchUpInside)
        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        logoBtn.imageView?.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoBtn)
        
        
        for case let textField as UITextField in self.view.subviews {
            self.anycolorborder(forview: textField, radius: 4,color: UIColor.lightGray)
        }
        self.anycolorborder(forview: self.btnUpdate, radius: 4,color: UIColor.lightGray)
        self.tableSearch.tableFooterView?.frame = CGRect.zero
        self.tableSearch.isHidden = true
        self.tableSearch.layer.cornerRadius = 10
        self.tableSearch.layer.masksToBounds = true
        self.tableSearch.tableFooterView = UIView(frame: .zero)
        tableSearch.layoutMargins = .zero
        tableSearch.separatorInset = .zero
        
    }
    @objc func logoClicked(_ sender: UIButton) {
        self.btnLogoBuffer.sendActions(for: .touchUpInside)
    }
    
    @objc func keyboardDismiss() {
        view.endEditing(true)
        self.tableSearch.isHidden = true
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
    // MARK: - GetAll DeviceList Method
    func partListApi()
    {
        if !ifLoading()
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
                            self.partAssignModel =  PartAssignModel.valueInitialization(jsonData: dict)
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

    func gettingSearchPartNOApi()
    {
        
            self.startloader(msg: "Loading.... ")
            Global.server.Get(path: "Part/CustomerbyPartNumber/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    if let dict = success as? [String : AnyObject] {
                    if(dict["IsSuccess"] != nil)
                    {
                        let success = dict["IsSuccess"] as? Bool ?? false
                        if (success)
                        {
                            self.partAssignSearchListModel =  PartAssignSearchListModel.valueInitialization(jsonData: dict)
                            if let partAssignArray = self.partAssignSearchListModel.arrayPartNumberList {
                                self.arrayPartNumber = partAssignArray.map({$0.partNumber ?? ""})
                                self.arrayDescriptionPartNumber = partAssignArray.map({$0.description ?? ""})
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
    
    // MARK: - Post API
    func callingPost(dictPost:NSMutableDictionary) {
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Part/UpdatePart", jsonObj: dictPost , completionHandler: {
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
                        if(msgs.characters.count>0)
                        {
                            
                            self.alert_handler(msgs: (dict.value(forKey: "Message") as? String ?? ""), dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        else
                        {
                            
                            self.alert_handler(msgs: "Part Number Updated Successfully", dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        
                    }
                    else
                    {
                        if(msgs.characters.count>0)
                        {
                            self.alert_handler(msgs: (dict.value(forKey: "Message") as? String ?? ""), dismissed: {_ in
                                
                            })
                        }
                        else
                        {
                            self.alert_handler(msgs: "Unable to Update Part Number now", dismissed: {_ in
                                
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
    
   func postApiAction() {
    for case let textField as UITextField in self.view.subviews {
        textField.text = ""
    }
    self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button action
    @IBAction func updateAction(_ sender: Any) {
        if txtPartNumber.text == "" {
            self.alert(msgs: "Choose the Part Name")
            
        } else if txtQuantity.text == "" {
            self.alert(msgs: "Fill the Required Quantity")
            
        } else if txtCavity.text == "" {
            self.alert(msgs: "Fill the Cavity")
            
        } else if txtCycleTime.text == "" {
            self.alert(msgs: "Fill the Cycle Time")
            
        } else if txtScarp.text == "" {
            self.alert(msgs: "Fill the Current Scarp")
        }else {
            var startDate = ""
            var id:Int64 = 0
            var deviceID:Int64 = 0
            
            if (istransitFromNotification) {
                if let partList = partAssignModel.arrayAssignedList {
                    let deviceName:[String] =  partList.map({$0.deviceName ?? ""})
                    if let choosenIndex = deviceName.index(of: passLabelName) {
                    startDate = partList[choosenIndex].startDate ?? ""
                        id  = partList[choosenIndex].id ?? 0
                        deviceID = partList[choosenIndex].deviceID ?? 0
                    }
                }
                
                print("inside notific")
                
            } else {
                startDate = self.arrayAssignedList.startDate ?? ""
                deviceID = self.arrayAssignedList.deviceID ?? 0
                print(deviceID)
                id = self.arrayAssignedList.id ?? 0
                
            }
           
                
                if let partNumber = txtPartNumber.text,
                    let cavity = txtCavity.text,
                    let cycleTime = txtCycleTime.text,
                    let quantity = txtQuantity.text,let currentScarp = txtScarp.text {
                    let dict:NSMutableDictionary = [
                        "PartNumber":partNumber,
                        "Cavity":Int(cavity) ?? 0 ,
                        "CycleTime":Double(cycleTime),
                        "RequiredQuantity": Int(quantity) ?? 0 ,
                        "Id": id,
                        "PartId": self.partID ,
                        "DeviceID": deviceID,
                        "StartDateTime": startDate ,
                        "DeviceName": passLabelName,
                        "CurrentScrap":currentScarp
                        ]
                    print(dict)
                    self.callingPost(dictPost: dict)
                }
                
                
            
            
       
        }
    }
    
    @IBAction func didSelectTable(_ sender: UIButton) {
        
        if let cell = sender.superview?.superview as? SearchCell {
            self.tableSearch.isHidden = true
            self.txtPartNumber.text = cell.lblPartName.text
            if arrayPassRefPartNO.contains((cell.lblPartName.text)!) {
                self.alert_handler(msgs: "This Part Number is already assigned", dismissed: {_ in
                    self.txtPartNumber.text = ""
                    
                })
            } else {
                if let selectedIndex:Int = self.arrayPartNumber.index(of: "\(cell.lblPartName.text!)") {
                    self.selectedIndex = selectedIndex
                    if let array = partAssignSearchListModel.arrayPartNumberList {
                        self.txtCavity.text = "\(array[selectedIndex].cavity ?? 0)"
                        self.txtCycleTime.text = "\(array[selectedIndex].cycleTime ?? 0.0)"
                        self.partID = "\(array[selectedIndex].partId ?? 0)"
                    }
                }
            }
        }
    }
    
    // MARK: - UITextfieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableview Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySearchPartNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        cell.lblPartName.text = arraySearchPartNumber[indexPath.row]
        print(arraySearchPartNumber[indexPath.row])
        cell.layoutMargins = .zero
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

