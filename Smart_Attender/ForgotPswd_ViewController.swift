//
//  PopupViewController.swift
//  Mtopo_Merchant
//
//  Created by CIPL-258-MOBILITY on 18/11/16.
//  Copyright © 2016 Peer Mohamed Thabib. All rights reserved.
//

import UIKit

class ForgotPswd_ViewController: UIViewController,UITextFieldDelegate {
    // MARK: - Connected Outlets
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var Submit_Button: UIButton!
    @IBOutlet weak var Cancel_Button: UIButton!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var popup_view: UIView!
    @IBOutlet weak var popup_yvalue: NSLayoutConstraint!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
        
        self.blueborder_dynamicradius(forview: self.popup_view, radius: 4)
        self.email_textfield.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.popupHeightConstraint.constant = portraitHeight * 0.455772
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animate_view(initial: self.view.frame.size.height, final: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.blueborder(forview: self.email_textfield)
        self.blueborder(forview: self.Submit_Button)
        self.blueborder(forview: self.Cancel_Button)
    }
    
    func animate_view(initial:CGFloat,final:CGFloat)
    {
        self.popup_yvalue.constant=initial
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0, options: [], animations: {
            self.popup_yvalue.constant=final
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func Cancel_click(sender: AnyObject?) {
        self.popup_yvalue.constant=0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.74, delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0, options: [], animations: {
            
            self.popup_yvalue.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
            self.view.alpha=0
            }, completion: { completed in
                if(completed){self.view.removeFromSuperview()}
        })
    }
    
    @IBAction func Submit_click(sender: AnyObject?) {
        if email_textfield.text == "" {
            self.alert(msgs: "You must enter a email-id to get password")
        }
        else
        {
            if self.validate_emailid(text: email_textfield.text!) {
                post_email(emailid: email_textfield.text!)
            }
            else
            {
                self.alert(msgs: "Please enter a valid email-id")
            }
        }
    }
    
    func post_email(emailid:String) {
        self.startloader(msg: "Loading.... ")
        let postdict:NSMutableDictionary=["EmailAddress":self.email_textfield.text!]
        Global.server.Post(path: "Account/ForgotPassword", jsonObj: postdict, completionHandler: {
            (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Message"] != nil)
                {
                    self.alert(msgs: dict.value(forKey: "Message") as? String ?? "")
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        self.Cancel_click(sender: nil)
                    }
                }
            }
            else
            {
               self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }
    
    // MARK: - UITextField protocol
//    private func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        textField.resignFirstResponder()
//        self.Submit_click(sender: nil)
//
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        var keyboardFrame:CGRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let space_needed:CGFloat=self.view.frame.maxY-self.popup_view.frame.maxY
        ViewUpanimateMoving(up: true, upValue: keyboardFrame.size.height-space_needed)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        self.view.frame.origin.y=0
    }
    
    func ViewUpanimateMoving (up:Bool, upValue :CGFloat){
        let durationMovement:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -upValue : upValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(durationMovement)
        self.view.frame.origin.y += movement
        UIView.commitAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.email_textfield.addSubview(leftview(fortextfield: self.email_textfield,imagename: "UserName"))
    }
}
