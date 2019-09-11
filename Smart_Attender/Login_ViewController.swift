//
//  ViewController.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 15/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController,UITextFieldDelegate {
    // MARK: - Connected Outlets
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var pswd_textfield: UITextField!
    @IBOutlet weak var Signi_button: UIButton!
    @IBOutlet weak var forgot_button: UIButton!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var dataApiTxtFld: UITextField!
    
    @IBOutlet var showhideImgBtn: UIButton!
    
    @IBOutlet var TickBtn: UIButton!
    var FinalescapedStr :String!
    var dataText:String = ""
    var dataSpace: String = ""
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.email_textfield.attributedPlaceholder=self.placeholder(text: "E-mail")
        self.pswd_textfield.attributedPlaceholder=self.placeholder(text: "Password")
        self.dataApiTxtFld.attributedPlaceholder=self.placeholder(text: "Enter Client Code")

        
        self.email_textfield.returnKeyType = .next
        self.pswd_textfield.returnKeyType = .done
        self.dataApiTxtFld.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollHeightConstraint.constant = portraitHeight - 64
        let tapview: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapview.delegate=self
        self.view.addGestureRecognizer(tapview)
    }
    override func viewWillAppear(_ animated: Bool) {
        var userName = UserDefaults.standard.string(forKey: "userName")
        var baseApiData = UserDefaults.standard.string(forKey: "BaseAPI")
        self.dataApiTxtFld.text = userName
        userDefaultAPIBase = baseApiData
        print(userDefaultAPIBase)
}
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.blueborder(forview: self.email_textfield)
        self.blueborder(forview: self.pswd_textfield)
        self.blueborder(forview: self.Signi_button)
        self.blueborder(forview: self.dataApiTxtFld)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.email_textfield.addSubview(leftview(fortextfield: self.email_textfield,imagename: "UserName"))
        self.pswd_textfield.addSubview(leftview(fortextfield: self.pswd_textfield,imagename: "padlock"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.scrollHeightConstraint.constant = portraitHeight - 64
    }
    
   /* func api(){
        self.startloader(msg: "Loading....")
        
        
        dataText = self.dataApiTxtFld.text ?? ""
        dataText = dataText.trimmingCharacters(in: .whitespacesAndNewlines)
        print(dataText)
        
        if let datatxt : String = dataText as String
        {
            let escapedString = datatxt.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            print(escapedString!)
            if escapedString == "usmfbsa" {
                FinalescapedStr = escapedString?.uppercased()
                
            }else{
                FinalescapedStr = escapedString
            }
            UserDefaults.standard.set(FinalescapedStr, forKey: "userName")
            print(UserDefaults.standard.set(FinalescapedStr, forKey: "userName"))
            //UserDefaults.set(self.dataCheck.text, forKey: "userName") //Sets the value of the specified default key in the standard application domain.
            
            let jsonURL = "http://smartattendtest.com/service/api/Account/LoginTypeUrl/\(FinalescapedStr!)"
            
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
                        //let myData = json["LoginModel"] as! NSDictionary
                        DispatchQueue.main.async {
                            
                            
                            let dataJson = json["Url"] as! String
                            BaseApi = dataJson
                            print(BaseApi)
                            UserDefaults.standard.set(dataJson, forKey: "BaseAPI")

                            self.dataApiTxtFld.isHidden = true
                            self.TickBtn.isHidden = true
                            self.stoploader()
                        }
                    }
                }
                catch {
                    self.stoploader()
                    
                    print("Error is : \n\(error)")
                }
                
                }.resume()
            self.stoploader()
            
            
        }
        
        
    }*/
    
    @IBAction func showhideImgActBtn(_ sender: Any) {
        if TickBtn.isHidden == false && self.dataApiTxtFld.isHidden == false {
            TickBtn.isHidden = true
            self.dataApiTxtFld.isHidden = true
            
        }
        else {
            TickBtn.isHidden = false
            self.dataApiTxtFld.isHidden = false
            
        }

    }
    @IBAction func tickMarkBtn(_ sender: Any) {
//        if dataApiTxtFld.text?.isEmpty ?? false{
//            BaseApi = "http://smartattendtest.com/service/api/"
//            self.dataApiTxtFld.isHidden = true
//            self.TickBtn.isHidden = true
//        }else{
//            dataText = self.dataApiTxtFld.text ?? ""
//             //self.api() //uncommand pannu
//        }

        var baseApiData2:String?
        
        if dataApiTxtFld.text?.isEmpty ?? false{
            UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
            BaseApi = "http://smartattendtest.com/service/api/"
            self.dataApiTxtFld.isHidden = true
            self.TickBtn.isHidden = true
        }else{
            dataText = self.dataApiTxtFld.text ?? ""
            if dataApiTxtFld.text == "USMFBSA"  {
                UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                baseApiData2 =  "http://10.31.239.31:82/service/api/"
                UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                self.TickBtn.isHidden = true
                self.dataApiTxtFld.isHidden = true
            }
            else if dataApiTxtFld.text == "usmfbsa"{
                UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                baseApiData2 =  "http://10.31.239.31:82/service/api/"
                UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                self.TickBtn.isHidden = true
                self.dataApiTxtFld.isHidden = true
            }
            else if dataApiTxtFld.text == "preprod" ||  dataApiTxtFld.text == "preprod "  {
                UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                dataApiTxtFld.text = dataSpace
                var trimmedString = dataSpace.trimmingCharacters(in: .whitespacesAndNewlines)
                trimmedString = "http://preprod.smartattendtest.com//service/api/"
                UserDefaults.standard.set(trimmedString, forKey: "baseApiDataF")
                print(trimmedString)
                self.TickBtn.isHidden = true
                self.dataApiTxtFld.isHidden = true
                
            }
            else {
                UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                baseApiData2 =  "http://smartattendtest.com/service/api/"
                UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                self.TickBtn.isHidden = true
                self.dataApiTxtFld.isHidden = true
                // self.api()
            }
            let baseApiDataF = UserDefaults.standard.string(forKey: "baseApiDataF")
            
            BaseApi = baseApiDataF ?? "http://smartattendtest.com/service/api/"
            
            
        }
        
    }
    
    @objc func viewTapped() {
        self.dismissKeyboard()
    }
    
        func post_login(email:String,pswd:String) {
            self.startloader(msg: "Loading....")
            var serverToken:String!
            if let deviceTokn = dfualts.value(forKey: "Device Token") as? String  {
    
                serverToken = deviceTokn
            }
            else
            {
                serverToken = "UnRegistered"
                UserDefaults.standard.setValue(serverToken, forKey: "Device Token")
            }
            let postdict:NSMutableDictionary = ["EmailAddress":email,"Password":pswd,"DeviceToken":serverToken,"DeviceType":"IOS"]
            Global.server.Post(path: "Account/LogIn", jsonObj: postdict, completionHandler: {
                (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let dict:NSDictionary=success as! NSDictionary
                    if(dict["Message"] != nil)
                    {
                        let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                        if (success)
                        {
                            let role:String=dict.value(forKey: "Role") as? String ?? ""
                            if(dict["Response"] != nil)
                            {
                                let data:NSDictionary=dict.value(forKey: "Response") as! NSDictionary
                                dfualts.setValue(data.value(forKey: "EmailAddress"), forKey: "email")
                                dfualts.setValue(role, forKey: "UserType")
                                account_email=dfualts.value(forKey: "email") as? String ?? ""
    
                                self.alertview(msgs: dict.value(forKey: "Message") as? String ?? "")
                                dfualts.setValue(true, forKey: "reload")
    
                                let AccountId:NSNumber = data.value(forKey: "AccountID") as? NSNumber ?? 0
                                let CustomerId:NSNumber = data.value(forKey: "CustomerID") as? NSNumber ?? 0
                                Global.userType.storeDefaults(AccountId: AccountId,CustomerId: CustomerId)
    
                                self.performSegue(withIdentifier: "Reveal_Adminmenu", sender: self)
    
    
    
                            }
                        }
                        else
                        {
                            self.alert(msgs: dict.value(forKey: "Message") as? String ?? "")
                        }
                    }
                }
                else
                {
                    self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
                }
            })
        }
    
 /*   func post_login(email:String,pswd:String) {
        self.startloader(msg: "Loading....")
        var serverToken:String!
        if let deviceTokn = dfualts.value(forKey: "Device Token") as? String  {
            
            serverToken = deviceTokn
        }
        else
        {
            serverToken = "UnRegistered"
            UserDefaults.standard.setValue(serverToken, forKey: "Device Token")
        }
        let postdict:NSMutableDictionary = ["EmailAddress":email,"Password":pswd,"DeviceToken":serverToken,"DeviceType":"IOS"]
        Global.server.Post(path: "Account/LogIn", jsonObj: postdict, completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Message"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        let role:String=dict.value(forKey: "Role") as? String ?? ""
                        if(dict["Response"] != nil)
                        {
                            let data:NSDictionary=dict.value(forKey: "Response") as! NSDictionary
                            dfualts.setValue(data.value(forKey: "EmailAddress"), forKey: "email")
                            dfualts.setValue(role, forKey: "UserType")
                            account_email=dfualts.value(forKey: "email") as? String ?? ""
                            
                            self.alertview(msgs: dict.value(forKey: "Message") as? String ?? "")
                            dfualts.setValue(true, forKey: "reload")
                            
                            let AccountId:NSNumber = data.value(forKey: "AccountID") as? NSNumber ?? 0
                            let CustomerId:NSNumber = data.value(forKey: "CustomerID") as? NSNumber ?? 0
                            Global.userType.storeDefaults(AccountId: AccountId,CustomerId: CustomerId)
                            let appType:Int = dict.value(forKey: "Apptype") as? Int ?? 0
                           // let appType = 3
                            
                            
                            if  appType == 1 || appType == 2 {
                                
                                isPreprodBaseURL = appType == 2 ? true : false
                                self.performSegue(withIdentifier: "Reveal_Adminmenu", sender: self)
                                
                            } else if appType == 3 {
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Smart Attend", message: "please choose one of the following options", preferredStyle: .actionSheet)
                                    let okAction = UIAlertAction(title: "Production URL", style: .default) {
                                        UIAlertAction in
                                        
                                        self.baseURLEntryApi(email:email,pswd:pswd, appType: 1)
                                        
                                    }
                                    
                                    let cancelAction = UIAlertAction(title: "Preproduction URL", style: .default) {
                                        UIAlertAction in
                                        
                                        self.baseURLEntryApi(email:email,pswd:pswd, appType: 2)
                                    }
                                    
                                    alertController.addAction(okAction)
                                    alertController.addAction(cancelAction)
                                    
                                    self.present(alertController, animated: true)
                                }
                            }
                            
                        }
                    }
                    else
                    {
                        self.alert(msgs: dict.value(forKey: "Message") as? String ?? "")
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
    
    func baseURLEntryApi(email:String,pswd:String,appType:Int) {
        self.startloader(msg: "Loading....")
        var serverToken:String!
        if let deviceTokn = dfualts.value(forKey: "Device Token") as? String  {
            
            serverToken = deviceTokn
        }
        else
        {
            serverToken = "UnRegistered"
            UserDefaults.standard.setValue(serverToken, forKey: "Device Token")
        }
        let postdict:NSMutableDictionary = ["EmailAddress":email,"Password":pswd,"DeviceToken":serverToken,"DeviceType":"IOS","Apptype":appType]
        Global.server.Post(path: "Account/ApptypeLogin", jsonObj: postdict, completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Message"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        isPreprodBaseURL = appType == 2 ? true :false
                        let role:String=dict.value(forKey: "Role") as? String ?? ""
                        if(dict["Response"] != nil)
                        {
                            let data:NSDictionary=dict.value(forKey: "Response") as! NSDictionary
                            dfualts.setValue(data.value(forKey: "EmailAddress"), forKey: "email")
                            dfualts.setValue(role, forKey: "UserType")
                            account_email=dfualts.value(forKey: "email") as? String ?? ""
                            
                            self.alertview(msgs: dict.value(forKey: "Message") as? String ?? "")
                            dfualts.setValue(true, forKey: "reload")
                            
                            let AccountId:NSNumber = data.value(forKey: "AccountID") as? NSNumber ?? 0
                            let CustomerId:NSNumber = data.value(forKey: "CustomerID") as? NSNumber ?? 0
                            Global.userType.storeDefaults(AccountId: AccountId,CustomerId: CustomerId)
                            
                            self.performSegue(withIdentifier: "Reveal_Adminmenu", sender: self)
                            
                            
                            
                        }
                    }
                    else
                    {
                        self.alert(msgs: dict.value(forKey: "Message") as? String ?? "")
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    } */
    
    // MARK: - Button Actions
    @IBAction func signin_click(_ sender: AnyObject?) {
        if(email_textfield.text=="" || pswd_textfield.text=="")
        {
            self.alert(msgs: "Please enter a valid login details")
        }
        else
        {
            if (self.validate_emailid(text: email_textfield.text!)) {
                self.post_login(email: email_textfield.text!, pswd: pswd_textfield.text!)
            }
            else
            {
                self.alert(msgs: "Please enter a valid email id")
            }
        }
    }
    
    @IBAction func forgotpswd_click(_ sender: AnyObject) {
        self.dismissKeyboard()
        let popview = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPswd_ViewController") as! ForgotPswd_ViewController
        self.addChildViewController(popview)
        popview.view.frame=self.view.frame
        self.view.addSubview(popview.view)
        popview.view.alpha=0
        popview.didMove(toParentViewController: self)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {() -> Void in
            popview.view.alpha=1
        }, completion: nil)
    }
    
    // MARK: - UITextField protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
//        textField.resignFirstResponder()
//        if textField == dataApiTxtFld {
//
//            if dataApiTxtFld.text?.isEmpty ?? false{
//                BaseApi = "http://smartattendtest.com/service/api/"
//                self.dataApiTxtFld.isHidden = true
//                self.TickBtn.isHidden = true
//            }else{
//                dataText = self.dataApiTxtFld.text ?? ""
//               // self.api() //uncommand pannu
//            }
//
//
//        }
//
//        if textField==email_textfield {
//            pswd_textfield.becomeFirstResponder()
//        }
//        else
//        {
//            self.signin_click( nil )
//        }
//
//
//        return true
        textField.resignFirstResponder()
        if textField == dataApiTxtFld{
            var baseApiData2:String?
            
            if dataApiTxtFld.text?.isEmpty ?? false{
                UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                BaseApi = "http://smartattendtest.com/service/api/"
                self.dataApiTxtFld.isHidden = true
                self.TickBtn.isHidden = true
            }else{
                dataText = self.dataApiTxtFld.text ?? ""
                if dataApiTxtFld.text == "USMFBSA"  {
                    UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                    baseApiData2 =  "http://10.31.239.31:82/service/api/"
                    UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                    self.TickBtn.isHidden = true
                    self.dataApiTxtFld.isHidden = true
                }
                else if dataApiTxtFld.text == "usmfbsa"{
                    UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                    baseApiData2 =  "http://10.31.239.31:82/service/api/"
                    UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                    self.TickBtn.isHidden = true
                    self.dataApiTxtFld.isHidden = true
                }
                else if dataApiTxtFld.text == "preprod" ||  dataApiTxtFld.text == "preprod "  {
                    UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                    dataApiTxtFld.text = dataSpace
                    var trimmedString = dataSpace.trimmingCharacters(in: .whitespacesAndNewlines)
                    trimmedString = "http://preprod.smartattendtest.com//service/api/"
                    UserDefaults.standard.set(trimmedString, forKey: "baseApiDataF")
                    print(trimmedString)
                    self.TickBtn.isHidden = true
                    self.dataApiTxtFld.isHidden = true
                    
                }
                else {
                    UserDefaults.standard.set(dataApiTxtFld.text, forKey: "userName")
                    baseApiData2 =  "http://smartattendtest.com/service/api/"
                    UserDefaults.standard.set(baseApiData2, forKey: "baseApiDataF")
                    self.TickBtn.isHidden = true
                    self.dataApiTxtFld.isHidden = true
                    // self.api()
                }
                let baseApiDataF = UserDefaults.standard.string(forKey: "baseApiDataF")
                
                BaseApi = baseApiDataF ?? "http://smartattendtest.com/service/api/"
                
                
            }
            
        }
        
        else if textField == email_textfield {
            pswd_textfield.becomeFirstResponder()
        }
        else
        {
            self.signin_click( nil )
        }
        return true
    }


    @objc func keyboardWillShow_Hide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            var contentInset:UIEdgeInsets = self.scroll_view.contentInset
            contentInset.bottom = keyboardFrame.size.height+12
            self.scroll_view.contentInset = contentInset
        }
        else {
            self.scroll_view.contentInset=UIEdgeInsets.zero
        }
    }
}
