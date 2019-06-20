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
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.email_textfield.attributedPlaceholder=self.placeholder(text: "E-mail")
        self.pswd_textfield.attributedPlaceholder=self.placeholder(text: "Password")
        
        self.email_textfield.returnKeyType = .next
        self.pswd_textfield.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollHeightConstraint.constant = portraitHeight - 64
        let tapview: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapview.delegate=self
        self.view.addGestureRecognizer(tapview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.blueborder(forview: self.email_textfield)
        self.blueborder(forview: self.pswd_textfield)
        self.blueborder(forview: self.Signi_button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.email_textfield.addSubview(leftview(fortextfield: self.email_textfield,imagename: "user_icon"))
        self.pswd_textfield.addSubview(leftview(fortextfield: self.pswd_textfield,imagename: "pswd_icon"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.scrollHeightConstraint.constant = portraitHeight - 64
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
        textField.resignFirstResponder()
        if textField==email_textfield {
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
