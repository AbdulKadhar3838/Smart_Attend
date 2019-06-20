//
//  Popup_MachinedetailsViewController.swift
//  Smart Attend
//
//  Created by CIPL-258-MOBILITY on 10/02/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import AVFoundation

class Popup_MachinedetailsViewController: UIViewController,UITextFieldDelegate  {
    // MARK: - Connected Outlets
    @IBOutlet weak var close_butn: UIButton!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var status_label: UILabel!
    @IBOutlet weak var popup_view: UIView!
    @IBOutlet weak var popup_yvalue: NSLayoutConstraint!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightDescripTxtvw: NSLayoutConstraint!
    @IBOutlet weak var outer_label: UILabel!
    var data_dict: NSDictionary=[:]
    @IBOutlet weak var popupHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtvwDescription: UITextView!
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.popup_yvalue.constant=self.view.frame.size.height
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = true
      //  self.blueborder_dynamicradius(forview: self.popup_view, radius: 4)
        self.title_label.text=data_dict.value(forKey: "DeviceName") as? String ?? ""
        self.status_label.text = data_dict.value(forKey: "InputName") as? String ?? ""
        self.txtvwDescription.text = data_dict.value(forKey: "Description") as? String ?? ""
        self.popupHeightConstraint.constant = portraitHeight * 0.26986
        
        txtvwDescription.textContainer.lineFragmentPadding = 0
        txtvwDescription.textContainerInset = .zero
        textviewheightCalculation()
        

    }
    
    func textviewheightCalculation() {
        if self.txtvwDescription.contentSize.height > self.txtvwDescription.frame.height {
            constraintHeightDescripTxtvw.constant = 140
            print("inside large size")
        } else {
            print("inside small size")
            constraintHeightDescripTxtvw.constant = (self.txtvwDescription.contentSize.height + 20) <= 140 ?  (self.txtvwDescription.contentSize.height + 20) : self.txtvwDescription.contentSize.height
            
        }
    }
    func outer_labelTapped() {
        self.Close_click( sender: nil )
    }
    override func viewDidAppear(_ animated: Bool) {
        self.animate_view(initial: self.view.frame.size.height, final: 0)
        self.anycolorborder(forview: self.close_butn, radius: 6, color: UIColor.clear)
    }

    // MARK: - UITextField protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func Close_click(sender: AnyObject?) {
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
                    dfualts.setValue(true, forKey: "reload")
                }
        })
    }
}

