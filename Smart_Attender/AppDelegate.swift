//
//  AppDelegate.swift
//  Smart_Attender
//
//  Created by CIPL-258-MOBILITY on 15/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let theme_color:UIColor = UIColor.init(netHex: 0x23238E)
let sky_Blue:UIColor = UIColor.init(netHex: 0x00B9F2)
let newGray_color:UIColor = UIColor.init(netHex:0xEDEDED)
let newDarkGray_color:UIColor = UIColor.init(netHex:0x525E6F)
let nav_color:UIColor = UIColor.init(netHex: 0x222287)
let SlidemenuNav_color:UIColor = UIColor.init(netHex: 0x2D2D2D)
let Yellow_color:UIColor = UIColor.init(netHex: 0xE5A530)
var currentShotdownId:Int?


let dropdown_array = ["Last 24 Hours", "Last 12 Hours", "Last 8 Hours"]
let alertTitle = "Smart Attend"
let chart_colors:[UIColor]=[UIColor.init(netHex: 0x63FA23), 
                            UIColor.init(netHex: 0xF33924),
                            UIColor.init(netHex: 0x85989E),
                            UIColor.init(netHex: 0xF9A207),
                            UIColor.init(netHex: 0xDB99D6),
                            UIColor.init(netHex: 0x62CCC0),
                            UIColor.init(netHex: 0x4396D8),
       UIColor.init(netHex: 0x55170A)]


func NavigationColourGradient(){
    
    
}


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var shouldRotate = true
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
     //   UINavigationBar.appearance().barTintColor = nav_color
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "status bar bg")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)

    
       // UINavigationItem.titleView = logoContainer
        
        UINavigationBar.appearance().tintColor=UIColor.white
       // UINavigationBar.appearance().isTranslucent=true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        DispatchQueue.main.async {
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
         
            
        }
        
        account_id=dfualts.value(forKey: AccountID) as? String ?? ""
        customer_id=dfualts.value(forKey: CustomerID) as? String ?? ""
        //forceUpdate() //Force update new version
        
        if (account_id.count > 0)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var identifier = ""
            if Global.userType.isAdmin() {
                identifier = "Reveal_Admin"
            } else if Global.userType.isOperator() {
                identifier = "Reveal_Operator"
            } else {
                identifier = "Reveal_Manager" 
            }
            //let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            let controller = storyboard.instantiateViewController(withIdentifier: "Reveal_Admin")
            if let window = self.window{
                window.rootViewController = controller
            }
        }
        
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        currentAppVersion = currentVersion
        print("currentVersion-->>\(currentVersion)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String , let resultJson = (json?["results"] as? [Any]) else {
                    throw VersionError.invalidResponse
                }
                print("App Strore latest version\(version)")
                print(resultJson)
                releaseVersion = version
                completion(version != currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        if token.characters.count>0
        {
            UserDefaults.standard.setValue(token, forKey: "Device Token")
        }
        
        print(token)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("i am not available in simulator \(error)")
        UserDefaults.standard.setValue("Simulator", forKey: "Device Token")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        if application.applicationState == .active
        {
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.timeZone = NSTimeZone.default
            let dict:NSDictionary = userInfo["aps"] as! NSDictionary
            if dict["alert"] != nil
            {
                localNotification.alertBody = dict.value(forKey: "alert") as? String ?? ""
            }
            if dict["badge"] != nil
            {
                localNotification.applicationIconBadgeNumber = dict.value(forKey: "badge") as? NSNumber as? Int ?? 0
            }
            localNotification.fireDate = Date.init(timeIntervalSinceNow: 0)
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        else{
            
        }
    }
    func trigger()
    {
        if (account_id != nil)
        {
            let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype == "Admin")
            {
                
            }
            else
            {
                let reload:Bool=dfualts.value(forKey: "reload") as? Bool ?? false
                if reload
                {
                    NotificationCenter.default.post(name: .reload_notific, object: self, userInfo: nil)
                }
            }
        }
    }
    
    //Force the app version update
    func forceUpdate() {
        _ = try? isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                print(update)
                isNewVersionAvailable = update
                if update {
                    if currentAppVersion > releaseVersion {
                        print("its Appstore Scenorio")
                        return
                    }
                    
                    let alert = UIAlertController(title: alertTitle, message: "A new version of Smart Attend is available.Please update to version \(releaseVersion) now", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {_ in
                        print("its Works!!!")
                        
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open((URL(string: "itms://itunes.apple.com/app/" + appStoreAppID)!), options:[:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id" + appStoreAppID)!)
                            
                        }
                        
                    }))
                    
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        account_id=dfualts.value(forKey: AccountID) as? String ?? ""
        self.trigger()
        
        //forceUpdate()//Force update New Verison
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      //  forceUpdate() //Force update New version
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        if (shouldRotate) {
            return UIInterfaceOrientationMask.all
        }
        else
        {
            return UIInterfaceOrientationMask.landscapeLeft
        }
    }
}

// MARK: - String Extension
extension String {
    func index(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func index_upper(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options)?.upperBound
    }
}


// MARK: - NSRange Extension
extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}

// MARK: - UIColor Extension
extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    convenience init(netHex_String:String) {
        let hexString:String = netHex_String.substring(from: netHex_String.index_upper(of: "#")!)
        let hexvalue = Int(hexString, radix: 16)
        self.init(red:(hexvalue! >> 16) & 0xff, green:(hexvalue! >> 8) & 0xff, blue:hexvalue! & 0xff)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let Linechart_Selectvalue = Notification.Name("Linechart_Selectvalue")
    static let Popup_Closed = Notification.Name("Popup_Closed")
    static let reload_notific = Notification.Name("Reload_Dashboard")
    static let other_datas = Notification.Name("others")
}

// MARK: - UIViewController Extension
extension UIViewController: UIGestureRecognizerDelegate
{
    
    func getSelectedHours()->Int
    {
        let selectedValue:Int = defalts.value(forKey: "hours_selected") as? Int ?? 0
        return selectedValue
    }
    func placeholder(text: String)->NSAttributedString
    {
        return NSAttributedString(string:text, attributes:[NSAttributedStringKey.foregroundColor: theme_color])
    }
    func blueborder(forview: UIView)
    {
        forview.clipsToBounds=true
        forview.layer.cornerRadius=forview.frame.size.height/2
        forview.layer.borderColor = theme_color.cgColor
        forview.layer.borderWidth = 1
    }
    func blueborder_dynamicradius(forview: UIView, radius: CGFloat)
    {
        forview.clipsToBounds=true
        forview.layer.cornerRadius=radius
        forview.layer.borderColor = theme_color.cgColor
        forview.layer.borderWidth = 1
    }
    func anycolorborder(forview: UIView, radius: CGFloat, color: UIColor)
    {
        forview.clipsToBounds=true
        forview.layer.cornerRadius=radius
        forview.layer.borderColor = color.cgColor
        forview.layer.borderWidth = 1
    }
    func leftview(fortextfield: UITextField, imagename: String) ->UIView
    {
        var widthValue:CGFloat
        
        if  (Global.IS.IPAD || Global.IS.IPAD_PRO)
        {
            widthValue=92
        }
        else if (Global.IS.IPHONE_4)
        {
            widthValue=52
        }
        else
        {
            widthValue=62
        }
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width:widthValue, height: fortextfield.frame.size.height+10))
        
        let imageView = UIImageView()
        let image = UIImage(named: imagename)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x:0, y:0 , width: widthValue/2.2, height: fortextfield.frame.size.height)
        imageView.center=leftView.center
        fortextfield.leftViewMode = UITextFieldViewMode.always
        fortextfield.leftView=leftView
        leftView.addSubview(imageView)
        return leftView
    }
    func leftviewTwo(fortextfield: UITextField, imagename: String) ->UIView
    {
        var widthValue:CGFloat
        
        if  (Global.IS.IPAD || Global.IS.IPAD_PRO)
        {
            widthValue=15
        }
        else if (Global.IS.IPHONE_4)
        {
            widthValue=0
        }
        else
        {
            widthValue=5
        }
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width:fortextfield.frame.size.height+widthValue, height: fortextfield.frame.size.height))
        
        let imageView = UIImageView()
        let image = UIImage(named: imagename)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x:0, y:0 , width: 0.8*fortextfield.frame.size.height, height: 0.6*fortextfield.frame.size.height)
        imageView.center=leftView.center
        fortextfield.leftViewMode = UITextFieldViewMode.always
        fortextfield.leftView=leftView
        leftView.addSubview(imageView)
        return leftView
    }
    func rightViewTwo(fortextfield: UITextField, imagename: String) ->UIView
    {
        var widthValue:CGFloat
        
        if  (Global.IS.IPAD || Global.IS.IPAD_PRO)
        {
            widthValue=15
        } else {
            widthValue=5
        }
        
        let rightViewTwo = UIView(frame: CGRect(x: 0, y: 0, width:fortextfield.frame.size.height + widthValue, height: fortextfield.frame.size.height))
        
        let imageView = UIImageView()
        let image = UIImage(named: imagename)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x:0, y:0 , width: 0.8*fortextfield.frame.size.height, height: 0.6*fortextfield.frame.size.height)
        imageView.center=rightViewTwo.center
        fortextfield.rightViewMode = UITextFieldViewMode.always
        fortextfield.rightView=rightViewTwo
        rightViewTwo.addSubview(imageView)
        return rightViewTwo
    }
    
    func rightView(fortextfield: UITextField, imagename: String) ->UIView
    {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width:fortextfield.frame.size.height, height: fortextfield.frame.size.height))
        
        let imageView = UIImageView()
        let image = UIImage(named: imagename)
        imageView.image = image
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width:rightView.frame.size.height * 0.8, height: rightView.frame.size.height * 0.6)
        imageView.center=rightView.center
        
        fortextfield.rightViewMode = UITextFieldViewMode.always
        
        fortextfield.rightView=rightView
        rightView.addSubview(imageView)
        return rightView
    }
    
    func pushDesiredVC(identifier :String) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: identifier)
        let nc = self.revealViewController().frontViewController as! UINavigationController
        nc.pushViewController(controller, animated: false)
        self.revealViewController().pushFrontViewController(nc, animated: true)
    }
    
    // MARK: - navigation title
    func toSetNavigationImagenTitle(titleString:String,isHamMenu:Bool) {
//        let selectedfont = UIFont(name:"IBMPlexSerif-Bold", size:22)
//        let _: [String: Any] = [NSAttributedStringKey.font.rawValue: selectedfont as Any]
        
        
//        let myString = "Swift Attributed String"
//        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "IBMPlexSerif-Bold", size: 18.0)! ]
//        var myAttrString = NSAttributedString(string: self.title ?? "DEFAULT", attributes: myAttribute)
//
         self.title = titleString
        
        //UIFont(name: "gameOver", size: 16)myAttrString.string = titleString
        
      
        
        
        if !isHamMenu {
            let logoBtn = UIButton(type: UIButton.ButtonType.custom)
            logoBtn.setImage(UIImage(named: "Dashboard"), for: .normal)
            logoBtn.tag = isHamMenu == true ? 1: 0
            logoBtn.addTarget(self, action: #selector(self.logoClicked) , for: .touchUpInside)
            logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            let barButton = UIBarButtonItem(customView: logoBtn)
            self.navigationItem.rightBarButtonItem = barButton
           
           // self.navigationController?.navigationBar.titleTextAttributes =
              //  [NSAttributedString.Key.foregroundColor: UIColor.red,
              //   NSAttributedString.Key.font: UIFont(name: "OpenSansRegular", size: 21)!]

            
            
//            let HomeImage = UIImage(named: "newSA")!
//            let Home : UIBarButtonItem = UIBarButtonItem(image: HomeImage,  style: .plain, target: self, action: Selector(("home:")))
//            navigationItem.rightBarButtonItem = Home
        }
    }
    
    @objc func logoClicked(sender:UIButton) {

        if sender.tag == 0 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            // Need to implement code for Dashboard
        }
    }
    @objc func logoClicked1(sender:UIButton){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
                self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    @objc func logoClickedSettings(sender:UIButton){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportVC") as! QuickSettingViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
             DispatchQueue.main.async {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
            self.view.alpha = 0.0;
            }
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    // MARK: - Alert Methods
    func alert(msgs: String)
    {
        let AlertController = UIAlertController(title: alertTitle, message: msgs, preferredStyle: UIAlertControllerStyle.alert)
        AlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async {
            self.present(AlertController, animated: true, completion: nil)
        }
    }
    func alertview(msgs: String) {
        let alertview:UIAlertView = UIAlertView.init(title: alertTitle, message: msgs, delegate: self, cancelButtonTitle: nil)
        alertview.show()
        alertview.dismiss(withClickedButtonIndex: 0, animated: true)
    }
    func alert_handler(msgs: String, dismissed: @escaping (Bool) ->())
    {
        let alertview = UIAlertController(title: alertTitle, message: msgs, preferredStyle: UIAlertControllerStyle.alert)
        alertview.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            alertaction in
            switch alertaction.style{
            case .default:
                dismissed(true)
            default: break
            }
        }))
        
        DispatchQueue.main.async {
            self.present(alertview, animated: true, completion: nil)
        }
    }
    func alertOkCancel(msgs: String, handlerCancel: @escaping (Bool) ->(), handlerOk: @escaping(Bool) ->())
    {
        let alertview = UIAlertController(title: alertTitle, message: msgs, preferredStyle: UIAlertControllerStyle.alert)
        alertview.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
            alertaction in
            switch alertaction.style{
            case .default:
                handlerCancel(true)
            default: break
            }
        }))
        alertview.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ action in
            handlerOk(true)
        }))
        
        DispatchQueue.main.async {
            self.present(alertview, animated: true, completion: nil)
        }
    }
    
    // MARK: - Email Validate
    func validate_emailid(text: String) -> (Bool)
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if (emailTest.evaluate(with: text))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    //MARK: - Convert Time Stramp to Decimal Value
    func convert_decimal(dict: NSDictionary) -> Double
    {
        let strTime:String!
        let formatter = DateFormatter()
        let graphType:String = defalts.value(forKey: "GraphType") as? String ?? ""
        if graphType == "HighLow" {
            strTime=(dict.value(forKey: "x") as? String ?? "")
            if strTime.contains(".") {
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            }
            else
            {
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            }
        }
        else
        {
            strTime=(dict.value(forKey: "period") as? String ?? "")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        //        let calendar = NSCalendar.current
        //        let hour = calendar.component(.hour, from: formatter.date(from: strTime)!)
        //        let minutes = calendar.component(.minute, from: formatter.date(from: strTime)!)
        //        let date_str="\(hour).\(minutes)"
        //        let decimal_time:Double = Double(date_str)!
        //        print(decimal_time)
        
        let since1970 = formatter.date(from: strTime)?.timeIntervalSince1970
        return since1970 ?? 0.0
    }
    
    //MARK: - No Data
    func showNodata(msgs:String)
    {
        let noDataLabel = UILabel()
        noDataLabel.text = msgs
        noDataLabel.numberOfLines=2
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.textAlignment=NSTextAlignment.center
        noDataLabel.textColor = UIColor.black
        noDataLabel.tag=2000
        self.view.addSubview(noDataLabel)
        
        let xConstraint = NSLayoutConstraint(item: noDataLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: noDataLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([xConstraint,yConstraint])
    }
    func hideNoData()
    {
        DispatchQueue.main.async{
            for loaderview:UIView in self.view.subviews
            {
                if (loaderview.tag==2000)
                {
                    loaderview.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Loader Methods
    func startloader(msg:String) {
        self.hideNoData()
        self.dismissKeyboard()
        print(msg)
        let messageFrame = UIView()
        var activityIndicator = UIActivityIndicatorView()
        let strLabel = UILabel()
        let bgFrame = UIView()
        
        messageFrame.layer.cornerRadius = 15
        messageFrame.translatesAutoresizingMaskIntoConstraints = false
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 35, y: 10, width: 60, height: 60)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        strLabel.text = msg
        strLabel.numberOfLines=2
        strLabel.translatesAutoresizingMaskIntoConstraints = false
        strLabel.textAlignment=NSTextAlignment.center
        strLabel.textColor = UIColor.white
        
        messageFrame.addSubview(strLabel)
        bgFrame.addSubview(messageFrame)
        bgFrame.tag=1000
        bgFrame.backgroundColor = UIColor(white: 0, alpha: 0.2)
        bgFrame.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bgFrame)
        
        
        //FOR activityIndicator
        let views = ["activityIndicator": activityIndicator]
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[activityIndicator(60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[activityIndicator(60)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(widthConstraints)
        NSLayoutConstraint.activate(heightConstraints)
        
        let xConstraint2 = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint2 = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([xConstraint2,yConstraint2])
        
        //FOR strLabel
        let widthConstraint0 = NSLayoutConstraint(item: strLabel, attribute: .width, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        let heightConstraint0 = NSLayoutConstraint(item: strLabel, attribute: .height, relatedBy: .equal,
                                                   toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let xConstraint0 = NSLayoutConstraint(item: strLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint0 = NSLayoutConstraint(item: strLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: activityIndicator.frame.height-20)
        NSLayoutConstraint.activate([widthConstraint0,heightConstraint0,xConstraint0,yConstraint0])
        
        
        //FOR messageFrame
        let widthConstraint1 = NSLayoutConstraint(item: messageFrame, attribute: .width, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        NSLayoutConstraint.activate([widthConstraint1])
        let heightConstraint1 = NSLayoutConstraint(item: messageFrame, attribute: .height, relatedBy: .equal,
                                                   toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 120)
        NSLayoutConstraint.activate([heightConstraint1])
        let xConstraint1 = NSLayoutConstraint(item: messageFrame, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint1 = NSLayoutConstraint(item: messageFrame, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint1,heightConstraint1,xConstraint1,yConstraint1])
        
        
        
        //FOR bgFrame
        let widthConstraint = NSLayoutConstraint(item: bgFrame, attribute: .width, relatedBy: .equal,
                                                 toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bgFrame, attribute: .height, relatedBy: .equal,
                                                  toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
        let xConstraint = NSLayoutConstraint(item: bgFrame, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: bgFrame, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([widthConstraint,heightConstraint,xConstraint,yConstraint])
    }
    func stoploader()
    {
        DispatchQueue.main.async{
            for loaderview:UIView in self.view.subviews
            {
                if (loaderview.tag==1000)
                {
                    loaderview.removeFromSuperview()
                }
            }
        }
    }
    func ifLoading() -> (Bool)
    {
        for loaderview:UIView in self.view.subviews
        {
            if (loaderview.tag==1000)
            {
                return true
            }
        }
        return false
    }
    
    // MARK: - Keyboard Methods
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addChildVCToParent (parent:UIViewController,child:UIViewController) {
        
                addChildViewController(child)
                view.addSubview(child.view)
                child.didMove(toParentViewController: parent)
        
        //parent.navigationController?.isNavigationBarHidden = true
        
    }
    
    func removeChildVC(child:UIViewController) {
        //child.parent?.navigationController?.isNavigationBarHidden = false
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
        
    }
    
}
extension UILabel{
    func asCircle(){
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
        //        self.layer.cornerRadius = self.frame.width / 2;
        //        self.layer.masksToBounds = true
    }
}
