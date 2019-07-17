//
//  ViewController.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 15/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit

class ResetPswd_ViewController: UIViewController {
    // MARK: - Connected Outlets
    @IBOutlet weak var cnfrmpswd_textfield: UITextField!
    @IBOutlet weak var newpswd_textfield: UITextField!
    @IBOutlet weak var pswd_textfield: UITextField!
    @IBOutlet weak var Submit_button: UIButton!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var inner_Scroll: UIView!
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var scrollview_topconstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        self.navigationController?.title = "Reset Password"
        
        toSetNavigationImagenTitle(titleString:"Reset Password", isHamMenu: true)
        
        
        
        
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "IBMPlexSerif-Bold", size: 20)!]
        

        
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
            // revealViewController().panGestureRecognizer()
            // view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.newpswd_textfield.returnKeyType = .next
        self.cnfrmpswd_textfield.returnKeyType = .done
        self.pswd_textfield.returnKeyType = .next
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.scrollHeightConstraint.constant = portraitHeight - 64
        let tapview: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        tapview.delegate=self
        self.inner_Scroll.addGestureRecognizer(tapview)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.scrollHeightConstraint.constant = portraitHeight - 64
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.blueborder(forview: self.cnfrmpswd_textfield)
        self.blueborder(forview: self.newpswd_textfield)
        self.blueborder(forview: self.pswd_textfield)
        self.blueborder(forview: self.Submit_button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cnfrmpswd_textfield.addSubview(leftview(fortextfield: self.cnfrmpswd_textfield,imagename: "padlock"))
        self.newpswd_textfield.addSubview(leftview(fortextfield: self.newpswd_textfield,imagename: "padlock"))
        self.pswd_textfield.addSubview(leftview(fortextfield: self.pswd_textfield,imagename: "padlock"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func submit_click(_ sender: AnyObject?) {
        
        
        if(cnfrmpswd_textfield.text=="" && pswd_textfield.text=="" && newpswd_textfield.text=="")
        {
            self.alert(msgs: "Please enter Current & New passwords")
        }
        else if( pswd_textfield.text=="")
        {
            self.alert(msgs: "Please enter Current password")
        }
        else if (newpswd_textfield.text=="")
        {
            self.alert(msgs: "Please enter New password")
        }
        else if (cnfrmpswd_textfield.text=="" )
        {
            self.alert(msgs: "Please enter confirm password")
        }
        else if (pswd_textfield.text == newpswd_textfield.text)
        {
            self.alert(msgs: "New password & Old password cannot be the same")
        }
        else
        {
            if (cnfrmpswd_textfield.text==newpswd_textfield.text) {
                self.post_reset(oldpwd: pswd_textfield.text!, newpwd: cnfrmpswd_textfield.text!)
            }
            else
            {
                self.alert(msgs: "New Password & Confirm Password does not match")
            }
        }
    }
    
        @IBAction func logoButtonImage(_ sender: Any) {
            self.pushDesiredVC(identifier: "dashboard2_ViewController")
        }
    
    // MARK: - Local Method
    
    @objc func viewTapped() {
        self.dismissKeyboard()
    }
    
    func post_reset(oldpwd:String,newpwd:String) {
        self.startloader(msg: "Loading....")
        let postdict:NSMutableDictionary = ["EmailAddress":account_email,"CurrentPassword":oldpwd,"NewPassword":newpwd]
        Global.server.Post(path: "Account/ResetPassword", jsonObj: postdict, completionHandler: {
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
                        self.alertview(msgs: dict.value(forKey: "Message") as? String ?? "")
                        self.Loggout()
                        
                        // self.performSegue(withIdentifier: "to_homeview", sender: self)
                        self.pushDesiredVC(identifier: "Login_ViewController")
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
    func Loggout()
    {
        Global.server.Post(path: "Account/Logout", jsonObj: ["DeviceToken":dfualts.value(forKey: "Device Token") as? String ?? ""], completionHandler: { (success,failure,noConnection) in
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        dfualts.setValue(nil, forKey: AccountID)
                    }
                }
            }
        })
    }
    
    // MARK: - UITextField protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if textField==pswd_textfield {
            newpswd_textfield.becomeFirstResponder()
        }
        else if textField==newpswd_textfield {
            cnfrmpswd_textfield.becomeFirstResponder()
        }
        else
        {
            self.submit_click( nil )
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
            scrollview_topconstraint.constant=64
            self.scroll_view.contentInset=UIEdgeInsets.zero
        }
    }
}
