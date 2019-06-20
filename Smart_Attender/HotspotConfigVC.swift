//
//  HotspotConfigVC.swift
//  Smart Attend
//
//  Created by CIPL0453MOBILITY on 21/03/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import Foundation
import SystemConfiguration.CaptiveNetwork

class HotspotConfigVC: UIViewController {
    
    // MARK: - Initialization
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var txtfdSSID: UITextField!
    @IBOutlet weak var txtfdSSIDPassword: UITextField!
    @IBOutlet weak var scrollParent: UIScrollView!
    @IBOutlet weak var constraintTopConnectbtn: NSLayoutConstraint!
    
    @IBOutlet weak var segmentConnectionMode: UISegmentedControl!
    @IBOutlet weak var btnConnect: UIButton!
    fileprivate var dbWLAN = ""
    
    fileprivate var dbPassword = ""
    var serverIPFirst:String = ""
    var serverIPSecond:String = ""
    var configIp1Address:String = ""
    var configIp2Address:String = ""
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        callingViewDidload()
        self.callingGetWLANPasswordApi(subURL: "Part/GetWifiandPassword")
    }
    
    // MARK: - Button Actions
    @IBAction func logoClicked(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    @IBAction func connectHotspotConnection(_ sender: Any) {
        if segmentConnectionMode.selectedSegmentIndex == 0 {
            let ssidName = (txtfdSSID.text!).trimmingCharacters(in: .whitespacesAndNewlines)
            let password = (txtfdSSIDPassword.text!).trimmingCharacters(in: .whitespacesAndNewlines)
            if ssidName == "" ||  password == ""{
                alert(msgs: "Fill the WLAN / Password")
            } else if password.count <= 7{
                alert(msgs: "Password must be more than 8 Characters")
            } else {
                self.startloader(msg: "Connecting...")
                
                if #available(iOS 11.0, *) {
                    let hotspotConfig = NEHotspotConfiguration(ssid: ssidName, passphrase: password, isWEP: false)
                    NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[unowned self] (error) in
                        print(error)
                        print(error?.localizedDescription)
                        if let error = error {
                            self.stoploader()
                            self.showError(error: error)
                        }
                        else {
                            self.stoploader()
                            if self.fetchSSIDInfo() == ssidName {
                                self.showSuccess()
                            }
                            
                            print(self.fetchSSIDInfo())
                        }
                    }
                    
                } else {
                    // Fallback on earlier versions
                    let alert = UIAlertController(title: "Hotspot Connection", message: "Please connect to hotspot manually, Setting->Wi-Fi", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) {_ in
                        self.stoploader()
                        self.manualConnection()
                       
                    }
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
           // navigateTcpandipConnectionVC() //Manual Connection Go to tcp/ip connection
            self.manualConnection()
        }
        
    }
    
    
    @objc func connectionMode(_ sender: UISegmentedControl) {
        
            if sender.selectedSegmentIndex == 0 { //Automatic 
               // txtfdSSID.isHidden = false
              //  txtfdSSIDPassword.isHidden = false
                btnConnect.setTitle("Connect", for: .normal)
               // updatingConstraintBtnConnect(segment: sender)
            } else { //Manual
               // updatingConstraintBtnConnect(segment: sender)
              //  txtfdSSID.isHidden = true
              //  txtfdSSIDPassword.isHidden = true
                let alert = UIAlertController(title: "Hotspot Manual Connection", message: "Please connect to hotspot manually, Setting->Wi-Fi", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) {_ in
                    self.manualConnection()
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        
        
        
        
    }
    
    // MARK: - Local Methods
    func manualConnection() {
        UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")! as URL)
     /*   if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:"App-Prefs:root=WIFI")!, options: [:], completionHandler: {_ in
                
            })
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")! as URL)
        } */
       // txtfdSSID.isHidden = true
       // txtfdSSIDPassword.isHidden = true
        navigateTcpandipConnectionVC()
        
    }
    func callingViewDidload() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        toSetNavigationImagenTitle(titleString:"Wifi Configuration", isHamMenu: true)
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        configTextfield()
        segmentConnectionMode.addTarget(self, action: #selector(self.connectionMode), for: .valueChanged)
    }
    
    func configTextfield() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    
    @objc func keyboardWillShow_Hide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            var contentInset:UIEdgeInsets = self.scrollParent.contentInset
            contentInset.bottom = keyboardFrame.size.height + 12
            self.scrollParent.contentInset = contentInset
        }
        else {
            self.scrollParent.contentInset=UIEdgeInsets.zero
        }
    }
    
  /*  func updatingConstraintBtnConnect(segment:UISegmentedControl) {
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: btnConnect, attribute: .top, relatedBy: .equal, toItem: segment.selectedSegmentIndex == 0 ? txtfdSSIDPassword:segmentConnectionMode, attribute: .bottom, multiplier: 1, constant: 40)
        constraintTopConnectbtn.isActive = false
        top_constraint.isActive = true
        constraintTopConnectbtn = top_constraint

    } */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.iki
    }
    
    func navigateTcpandipConnectionVC() {
        let tcpConnection = self.storyboard?.instantiateViewController(withIdentifier: "TcpConnectionVC") as! TcpConnectionVC
        tcpConnection.serverIPFirst =  serverIPFirst
        tcpConnection.serverIPSecond = serverIPSecond
        tcpConnection.configIp1Address = configIp1Address
        tcpConnection.configIp2Address = configIp2Address
        self.navigationController?.pushViewController(tcpConnection, animated: true)
    }
}

 

// MARK: - Api Methods
 extension HotspotConfigVC{
    
    // MARK: - New Part Post Api
    func callingGetWLANPasswordApi(subURL:String) {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: subURL, jsonObj: nil , completionHandler: {
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
                        DispatchQueue.main.async {
                            
                            let deviceConfig = dict.value(forKey: "deviceConfigModel") as! NSDictionary
                            self.txtfdSSID.text = deviceConfig.value(forKey: "WLAN_SSID") as? String ?? ""
                            self.txtfdSSIDPassword.text = deviceConfig.value(forKey: "WLAN_Password") as? String ?? ""
                            
    
                            self.serverIPFirst = deviceConfig.value(forKey: "ServerIPFirst") as? String ?? ""
                            self.serverIPSecond = deviceConfig.value(forKey: "ServerIPSecond") as? String ?? ""
                            self.configIp1Address = deviceConfig.value(forKey: "ConfigIp1Address") as? String ?? ""
                            self.configIp2Address = deviceConfig.value(forKey: "ConfigIp2Address") as? String ?? ""
                            
                        }
                        var message:String = ""
                        if(msgs.characters.count>0){
                            
                            message = (dict.value(forKey: "Message") as? String ?? "")
                            
                        } else {
                            
                            message = "WLAN and Password get Succesfully"
                        }
                        
                    }
                    else
                    {
                        var message:String = ""
                        if(msgs.count>0) {
                            
                            message = (dict.value(forKey: "Message") as? String ?? "")
                            
                        } else {
                            message = "WLAN and Password unable to retry"
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            
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
extension HotspotConfigVC {
    // MARK: - Hotspot
    func showError(error: Error) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            
            if error.localizedDescription == "already associated."{
                self.navigateTcpandipConnectionVC()
                /*  if let addr = self.getIPAddress() {
                 self.txtfdIP.text = addr
                 
                 } else {
                 print("No WiFi address")
                 } */
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showSuccess() {
        let alert = UIAlertController(title: "Wi-Fi Connection", message: "Connected", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            self.navigateTcpandipConnectionVC()
            /*   if let addr = self.getIPAddress() {
             // self.txtfdIP.text = addr
             
             } else {
             print("No WiFi address")
             } */
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
     func fetchSSIDInfo() ->  String {
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    currentSSID = ((interfaceData as? [String : AnyObject])?["SSID"])! as! String
                    
                }
            }
        }
        return currentSSID
    }
    
}

