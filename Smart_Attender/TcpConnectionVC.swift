//
//  TCPconnectionVC.swift
//  Smart Attend
//
//  Created by CIPL0453MOBILITY on 22/03/18.
//  Copyright © 2018 Colan. All rights reserved.
//

import UIKit
import SwiftSocket

class TcpConnectionVC: UIViewController {
    // MARK: - Initializations
    
    @IBOutlet weak var scrollParent: UIScrollView!
    @IBOutlet weak var txtfdWLAN: UITextField!
    @IBOutlet weak var txtfdIPAddress: UITextField!
    
    @IBOutlet weak var btnServerUpdate: UIButton!
    @IBOutlet weak var txtfdPassword: UITextField!
    var client: TCPClient?
    var isContinue:Bool = true
    var arrayHardwareData:[String] = []
    let ipAddress = "192.168."
    var middleIPAddress = ""
    let lastIPAddress = ".1" //Client Req is .1
    let portNo = "8887" // Client port Number
   //  let portNo = "8080" //Testing Port Number
    var counter = 0
    var serverIPFirst:String = ""
    var serverIPSecond:String = ""
    var configIp1Address:String = ""
    var configIp2Address:String = ""
    
    //DropDown
    
    @IBOutlet weak var txtfdDeviceName: UITextField!
    fileprivate var arrayPicker:[String] = []
    fileprivate var deviceID:Int64 = 0
    fileprivate var arrayDeviceID:[Int64] = []
    fileprivate var pickerView = UIPickerView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        callingViewDidload()
        // gettingIPAddress()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Methods
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if txtfdDeviceName.text == "" || txtfdDeviceName.text == nil || txtfdDeviceName.text == "--Select--" {
            alert(msgs: "Fill the Device Name")
        } else if txtfdWLAN.text == "" || txtfdPassword.text == "" {
            alert(msgs: "Fill the WLAN / Password")
        } else {
            counter = 0
            let WLANname = (txtfdWLAN.text!).trimmingCharacters(in: .whitespacesAndNewlines)
            let password = (txtfdPassword.text!).trimmingCharacters(in: .whitespacesAndNewlines)
            let strDeviceID = "$ID:" + String(deviceID) + "#"
            arrayHardwareData = ["$APP CONFIG UPDATE:1#",strDeviceID,"$SERN:\(WLANname)#","$SERP:\(password)#","$CONFIG COMPLETE#"]
            
            print(counter)
            isContinue = true
            tcpClient(msg: arrayHardwareData[0])
            
            
            
        }
        
    }
    
    
    @IBAction func serverUpdate(_ sender: UIButton) {
        if Global.network.connectedToNetwork()
        {
                self.afterSendingServer()
        } else {
            self.alert_handler(msgs: "No Internet access.Make sure that Wi-Fi or mobile data is turned on,then try again.", dismissed: {_ in
                UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")! as URL)
            })
        }
        
        
    }
    // MARK: - Local Methods
    func callingViewDidload() {
        self.btnServerUpdate.isHidden = true
        self.title = "TCP/IP Connection"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow_Hide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Picker Config
        pickerView.delegate = self
        txtfdDeviceName.inputView = pickerView
        txtfdDeviceName.addSubview(self.rightViewTwo(fortextfield: txtfdDeviceName,imagename: "Tick"))
        addDoneButtonOnKeyboard(txtfd: txtfdDeviceName, selector: #selector(doneFortxtfdDeviceName), title: "Done")
        
        arrayPicker = arrayGlobalMachineName
        arrayPicker.insert("--Select--", at: 0)
        arrayDeviceID = arrayGlobalDeviceIDwtfMachineName
        arrayDeviceID.insert(0, at: 0)
        
    }
    
    @objc func cancelPickerView() {
        
        txtfdDeviceName.text = ""
        self.dismissKeyboard()
    }
    
    @objc func doneFortxtfdDeviceName(sender:UITextField)
    {
        self.dismissKeyboard()
        if txtfdDeviceName.text == "" ||  txtfdDeviceName.text == nil || txtfdDeviceName.text == "--Select--"{
            alert(msgs: "Choose the Device Name")
        }
    }
    
    func addDoneButtonOnKeyboard(txtfd:UITextField,selector:Selector,title:String)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style:.plain, target: self, action: #selector(cancelPickerView))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style:.plain, target: self, action: selector)
        
        var items = [UIBarButtonItem]()
        
        items.append(cancel)
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtfd.inputAccessoryView = doneToolbar
        
    }
    
    func gettingIPAddress() {
        if let ipAddressFromWifi = getIPAddress() {
            txtfdIPAddress.text = ""
            middleIPAddress = ""
             let totalArray =  ipAddressFromWifi.components(separatedBy: ".")
                print(ipAddressFromWifi)
            
                //print(totalArray[2])
            middleIPAddress = totalArray.count > 3 ? totalArray[2] : ""
            
            
            txtfdIPAddress.text = ipAddress + middleIPAddress + lastIPAddress //Client Requirement
           // txtfdIPAddress.text = "172.20.10.8" //Static Ip address

        }
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
    
    func tcpClient(msg:String) {
        self.startloader(msg: "Updating...")
        
        client = TCPClient(address:txtfdIPAddress.text ?? ""/*ipAddress + middleIPAddress + lastIPAddress*/ , port: Int32(portNo)!)
        
       // client = TCPClient(address:"10.0.1.1"/*ipAddress + middleIPAddress + lastIPAddress*/ , port: Int32(portNo)!)
        
        switch client?.connect(timeout: 25) {
            
        case .success?:
            print("ttt")
            sendMessageAfterTCPConnected(msg: msg)
            
        case .failure(let error)?:
            self.stoploader()
            print(error)
            showError(error: error)
        case .none:
            self.stoploader()
            return
        }
        
        
    }
    
    func sendMessageAfterTCPConnected(msg:String) {
        
        switch client?.send(string: msg ) {
            
        case .success?:
            
            if counter == 4 {
                self.stoploader()
                self.alertMsg()
                
            }
            if isContinue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // change 5 to desired number of seconds
                    // Your code with delay
                    guard let data = self.client?.read(1024*10) else {
                        self.stoploader()
                        self.alert(msgs: "There is no response from machine, Try again")
                        return
                    }
                    
                    if let response = String(bytes: data, encoding: .utf8) {
                        print("response--->>>\(response)") //OK
                        if response == "OK" || response != ""{
                            
                            self.counter += 1
                            if self.counter == 5 {
                                self.counter = 0
                                self.isContinue = false
                                self.stoploader()
                            }
                            
                            if self.isContinue {
                                // self.tcpClient(msg: self.arrayHardwareData[self.counter])
                                self.sendMessageAfterTCPConnected(msg: self.arrayHardwareData[self.counter])
                                
                            }
                            print(self.counter)
                        }
                    } else {
                        self.stoploader()
                        self.alert(msgs: "There is no response, Try again")
                    }
                }
            }
            
            
            
        case .failure(let error)?:
            self.stoploader()
            print(error)
            showError(error: error)
        case .none:
            self.stoploader()
        }
    }
}

// MARK: - Textfeild Delegate & Error, Alert Message
extension TcpConnectionVC :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  textField == txtfdDeviceName {
            gettingIPAddress()
        }
    }
    
    
    
    func alertMsg() {
        let alert = UIAlertController(title: "TCP/IP Connection", message: "Data send to the Machine successfully and please reconnect the wifi ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=WIFI")! as URL)
            self.btnServerUpdate.isHidden = false
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showError(error: Error) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            
            if error.localizedDescription == "already associated."{
                
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Update Wifi Password Post Api
extension TcpConnectionVC {
    
    func callingGetWLANPasswordApi(dict:NSMutableDictionary) {
        
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Part/UpdateWifiPassword", jsonObj: dict , completionHandler: {
            (success,failure,noConnection) in
            DispatchQueue.main.async {
                self.stoploader()
            }
            
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
                            message = "WLAN and Password updated Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                            
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
                            message = "Unable to update WLAN and Password to DB"
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
    
    func afterSendingServer() {
        let dict:NSMutableDictionary = [
            "DeviceID": deviceID,
            "WLAN_Password": txtfdPassword.text ?? "",
            "WLAN_SSID":txtfdWLAN.text ?? "",
            "ServerIPFirst": self.serverIPFirst,
            "ServerIPSecond": self.serverIPSecond,
            "ConfigIp1Address": self.configIp1Address,
            "ConfigIp2Address": self.configIp2Address
        ]
        print(dict)
        
        self.callingGetWLANPasswordApi(dict: dict)
        
    }
    
    // MARK: - GetIPAddress
    func getIPAddress()-> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
}

// MARK: - Pickerview Protocol Methods
extension TcpConnectionVC:UIPickerViewDelegate,UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrayPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtfdDeviceName.text = arrayPicker[row]
        deviceID = arrayDeviceID[row]
    }
    
    
    
}
