//
//  NewUserVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class NewUserVC: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate{
    // MARK: - Initialization
    @IBOutlet weak var txtfdFirstName: UITextField!
    @IBOutlet weak var txtfdToDate: UITextField!
    @IBOutlet weak var txtfdFromDate: UITextField!
    @IBOutlet weak var txtfdContact: UITextField!
    @IBOutlet weak var txtfdPassword: UITextField!
    @IBOutlet weak var txtfdEmail: UITextField!
    @IBOutlet weak var txtfdUserRole: UITextField!
    @IBOutlet weak var txtfdLastName: UITextField!
    @IBOutlet weak var imgvwProfile: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var imgvwStatusActive: UIImageView!
    @IBOutlet weak var imgvwStatusInActive: UIImageView!
    @IBOutlet weak var imgvwEmailActive: UIImageView!
    @IBOutlet weak var imgvwEmailInActive: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var switchEmailNotific: UISwitch!
    @IBOutlet weak var switchStatus: UISwitch!
    
    @IBOutlet weak var btnLogoBuffer: UIButton!
    
    var arrayTxtfd:[UITextField] = []
    var arrayPicker:[String] = []
    let imagepicker = UIImagePickerController()
    var pickerView = UIPickerView()
    var dictPost:NSMutableDictionary = [:]
    var isValidated = false
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callingViewDidload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    
    // MARK: - Local Method
    func callingViewDidload() {
        arrayTxtfd = [txtfdFirstName,txtfdToDate,txtfdFromDate,txtfdContact,txtfdPassword,txtfdEmail,txtfdUserRole,txtfdLastName]
        arrayPicker = ["--Select Role --","Admin","Manager","Operator"]
        txtfdUserRole.placeholder = "--Select Role--"
        
         settingUI()
        self.title = "ADD ACCOUNT"
    
        let logoBtn = UIButton(type: .system)
        logoBtn.setImage(#imageLiteral(resourceName: "Dashboard"), for: .normal)
        logoBtn.addTarget(self, action: #selector(self.logoClicked(_:)) , for: .touchUpInside)
        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        logoBtn.imageView?.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoBtn)
        
        self.imagepicker.delegate = self
        self.pickerView.delegate = self
        txtfdUserRole.inputView = pickerView
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
    }

    func settingUI() {
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        DispatchQueue.main.async {
            for textfield in self.arrayTxtfd {
             self.anycolorborder(forview: textfield, radius: 4,color: UIColor.lightGray)
        }
            self.anycolorborder(forview: self.btnBack, radius: 4,color: UIColor.lightGray)
            self.anycolorborder(forview: self.btnCreate, radius: 4,color: Yellow_color)
        
            self.view.layoutIfNeeded()
            self.btnProfile.layer.cornerRadius = self.btnProfile.bounds.size.height/2
            self.btnProfile.clipsToBounds = true
           
            self.txtfdFromDate.addSubview(self.rightView(fortextfield: self.txtfdFromDate,imagename: "calendar-1"))
            self.txtfdToDate.addSubview(self.rightView(fortextfield: self.txtfdToDate,imagename: "calendar-1"))
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(self.keyboardDismiss))
        view.addGestureRecognizer(tap)
        addDoneButtonOnKeyboard(txtfd: txtfdUserRole, selector: #selector(doneButtonUserRole))
        addDoneButtonOnKeyboard(txtfd: txtfdFromDate, selector: #selector(doneButtonFromDate))
        addDoneButtonOnKeyboard(txtfd: txtfdToDate, selector: #selector(doneButtonToDate))
    }
    
    //  Keyboard Function
     @objc func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func keyboardDismiss() {
        view.endEditing(true)
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
    
     @objc func doneButtonUserRole(sender:UITextField)
    {
        self.txtfdEmail.becomeFirstResponder()
    }
    
    @objc func doneButtonFromDate()
    {
        self.txtfdToDate.becomeFirstResponder()
    }
    
    @objc func doneButtonToDate()
    {
        dismissKeyboard()
    }

    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func isPwdLenth(password: String) -> Bool {
        if password.characters.count <= 7 {
            return true
        }else{
            return false
        }
    }
    
    // For Dismiss n Reset All Values after API hitting
    func postApiAction() {
       txtfdFirstName.text = ""
        arrayTxtfd.map({$0.text = ""})
        self.navigationController?.popViewController(animated: true)
    }
    

    func validatingTextfield() {
        isValidated = false
        if txtfdFirstName.text == "" {
            self.alert(msgs: "Fill the First Name")
            
        } else if txtfdLastName.text == "" {
            self.alert(msgs: "Fill the Last Name")
            
        } else if (txtfdUserRole.text == "--Select Role --") || (txtfdUserRole.text == "")  {
            self.alert(msgs: "Select the user role")
            
        } else if txtfdEmail.text == "" {
            self.alert(msgs: "Fill the email id")
            
        } else if !validateEmail(candidate: txtfdEmail.text!) {
            self.txtfdEmail.text = ""
            self.alert(msgs: "Invalid Email format, eg abcd@gmail.com ")
            
        } else if txtfdPassword.text == "" {
            self.alert(msgs: "Fill the Password")
           
        }
        else if isPwdLenth(password: txtfdPassword.text!) {
            self.txtfdPassword.text = ""
            self.alert(msgs: "Password length should grater than 7")
            
        }else if txtfdContact.text == "" {
            self.alert(msgs: "Fill the Mobile No")
            
        } else if txtfdContact.text?.characters.count != 14 {
            self.alert(msgs: "The Mobile Number is too Short")
            self.txtfdContact.text = ""
            
        }else {
            var userRole:Int = 0
            var vacationFrom = ""
            var vacationTO = ""
            
            if (txtfdFromDate.text == "") || (txtfdFromDate.text == nil) {
                vacationFrom = ""
            } else {
                vacationFrom = txtfdFromDate.text ?? ""
            }
            
            if (txtfdToDate.text == "") || (txtfdToDate.text == nil) {
                vacationTO = ""
            } else {
                vacationTO = txtfdToDate.text ?? ""
            }
            
            if let userRoleNO = txtfdUserRole.text {
                if userRoleNO == "Admin" {
                    userRole = 2
                    
                } else if userRoleNO == "Manager" {
                    userRole = 3
                    
                } else {
                    userRole = 5 //Operator
                }
                
            }
            
            var imageString64:String = ""
            if self.btnProfile.currentBackgroundImage != #imageLiteral(resourceName: "UserAvator") && self.btnProfile.currentBackgroundImage != nil{
                
                if let imageData:Data = UIImageJPEGRepresentation(self.btnProfile.currentBackgroundImage!, 0.6) {
                    imageString64 = imageData.base64EncodedString(options: .lineLength64Characters)
                } else {
                    imageString64 = ""
                }
                
            }  else {
                imageString64 = ""
            }
            
            if let contact = txtfdContact.text,
                let email = txtfdEmail.text,
                let firstName = txtfdFirstName.text,
                let lastName = txtfdLastName.text,
                let password = txtfdPassword.text   {
                let dict:NSMutableDictionary = [
                    "ContactNo":contact,
                    "CustomerID":customer_id!,
                    "EmailAddress":email,
                    "FirstName": firstName,
                    "IsEmailNotification":self.switchEmailNotific.isOn,
                    "Status":self.switchStatus.isOn,
                    "LastName":lastName,
                    "Password":password,
                    "UserRoleID":userRole,
                    "VacationDateFrom":vacationFrom,
                    "VacationDateTo":vacationTO,
                    "Image":imageString64
                ]
                print(dict)
                
       self.dictPost = dict
            }
            isValidated = true
    }
        
    }
    // MARK: - Post API
    func callingPost(dictPost:NSMutableDictionary) {
        self.startloader(msg: "Loading.... ")
        Global.server.Post(path: "Account/CreateUser", jsonObj: dictPost , completionHandler: {
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
                            
                            self.alert_handler(msgs: "User created Succesfully", dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        
                    }
                    else
                    {
                        if(msgs.characters.count>0)
                        {
                            self.alert_handler(msgs: (dict.value(forKey: "Message") as? String ?? ""), dismissed: {_ in
                                self.postApiAction()
                            })
                        }
                        else
                        {
                            self.alert_handler(msgs: "Unable to create user now", dismissed: {_ in
                                self.postApiAction()
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
    
   // MARK: - Button Actions
    @IBAction func createUser(_ sender: UIButton){
        self.validatingTextfield()
        if isValidated {
            print(self.dictPost)
            self.callingPost(dictPost: self.dictPost)
        }
    }
    
     @IBAction func setpictureAction(_ sender: UIButton){
        
        let alertController = UIAlertController(title: "Profile Picture", message: "Choose Profile Picture", preferredStyle:.actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style:.default)
        {
            (result : UIAlertAction) -> Void in
            
            self.imagepicker.allowsEditing  = false
            self.imagepicker.sourceType = .photoLibrary
            self.present(self.imagepicker,animated: true,completion: nil)
            
            
            print("You pressed OK")
        }
        alertController.addAction(photoLibraryAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        {
            (result : UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagepicker.allowsEditing  = false
                self.imagepicker.sourceType = .camera
                self.imagepicker.cameraCaptureMode = .photo
                self.imagepicker.modalPresentationStyle = .fullScreen
                
                
                self.present(self.imagepicker,animated: true,completion: nil)
            }
            else{
                self.alert(msgs: "This device has no camera")
            }
            
            print("You pressed camera")
        }
        alertController.addAction(cameraAction)
        
        let cancelbuttonAction = UIAlertAction(title: "Cancel", style:.cancel)
        {
            (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(cancelbuttonAction)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = imgvwProfile
            popoverPresentationController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
      //  self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func fromDateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(self.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
      
    txtfdFromDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func logoClicked(_ sender: UIButton) {
        self.btnLogoBuffer.sendActions(for: .touchUpInside)
    }
    @IBAction func toDateEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = Date().tomorrow
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerToValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtfdToDate.text = dateFormatter.string(from: sender.date)
    }
    // MARK: - UIImageControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        self.btnProfile.setBackgroundImage(pickedImage, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UITextfieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtfdFirstName
        {
            self.txtfdLastName.becomeFirstResponder()
        }
        else if textField == txtfdLastName
        {
            self.txtfdUserRole.becomeFirstResponder()
        }
        else if textField == txtfdUserRole
        {
            self.txtfdEmail.becomeFirstResponder()
        }
        else if textField == txtfdEmail
        {
            self.txtfdPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == txtfdContact{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
            
        }else{
            
            return true
        }
    }
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.characters.count < 3{
            
            if str!.characters.count == 1{
                
                txtfdContact.text = "("
            }
            
        }else if str!.characters.count == 5{
            
            txtfdContact.text = txtfdContact.text! + ") "
            
        }else if str!.characters.count == 10{
            
            txtfdContact.text = txtfdContact.text! + "-"
            
        }else if str!.characters.count > 14{
            
            return false
        }
        
        return true
    }
    
    // MARK: - Pickerview Protocol Methods
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
        txtfdUserRole.text = arrayPicker[row]
    }
    // MARK: - To Do
   // Date Picker in Calendar and Profile picture Coding
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

