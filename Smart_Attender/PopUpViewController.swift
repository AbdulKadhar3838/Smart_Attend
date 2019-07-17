

import UIKit


class PopUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblViewPopup: UITableView!

    @IBOutlet var viewPopup: UIView!
    var DeviceID = [Int]()
    var DeviceName = [String]()
    var BtnColour = [String]()
    var DeviceMessage = [String]()
    var machineNameArray:NSMutableArray=[]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        
        self.showAnimate()
        self.api()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewPopup.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeviceName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        var ID:String?
        ID = String(DeviceID[indexPath.row])
        cell.lblNo.text = "(" + ID! + ")" ?? ""
        cell.lblName.text  = DeviceName[indexPath.row]
        cell.colourBtn.backgroundColor = UIColor(netHex_String: BtnColour[indexPath.row])
        cell.statusLbl.text = DeviceMessage[indexPath.row]
        print(BtnColour)
        cell.viewBtn.tag = indexPath.row
        
        cell.viewBtn.addTarget(self, action: #selector(viewActionBtn(_:)), for: .touchUpInside)
      //  cell.viewBtn.backgroundColor
        return cell
    }
    
    @IBAction func seeAllBtnAction(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard1_ViewController") as! dashboard1_ViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
}
    func show_popup(indexpath: IndexPath, view: UITableView)
    {
        let selectedCell:Dashboard1_TableViewCell = view.cellForRow(at: indexpath)! as! Dashboard1_TableViewCell
        selectedCell.contentView.backgroundColor = selectedCell.contentView.backgroundColor//UIColor.clear
        
        if indexpath.row<=self.machineNameArray.count
        {
            let data_dict:NSDictionary=machineNameArray.object(at: indexpath.row) as! NSDictionary
            dfualts.setValue(false, forKey: "reload")
            
            let usertype:String=dfualts.value(forKey: "UserType") as? String ?? ""
            if (usertype.lowercased() == "admin") || Global.userType.isManager()
            {
                let popview = self.storyboard?.instantiateViewController(withIdentifier: "MachineDetails_ViewController") as! MachineDetails_ViewController
                popview.data_dict=data_dict
                self.addChildViewController(popview)
                popview.view.frame=self.view.frame
                self.view.addSubview(popview.view)
                popview.didMove(toParentViewController: self)
            }
            else
            {
                let popview2 = self.storyboard?.instantiateViewController(withIdentifier: "Popup_MachinedetailsViewController") as! Popup_MachinedetailsViewController
                popview2.data_dict=data_dict
                self.addChildViewController(popview2)
                popview2.view.frame=self.view.frame
                self.view.addSubview(popview2.view)
                popview2.didMove(toParentViewController: self)
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func post_notificinfo(indexpath: IndexPath,view: UITableView) {
        let data_array:NSDictionary = machineNameArray.object(at: indexpath.row) as! NSDictionary
        let notific_id:NSNumber=data_array.value(forKey: "NotificationID") as? NSNumber ?? 0
        self.startloader(msg: "Loading.... ")
        let postdict:NSMutableDictionary=["NotificationID":notific_id]
        Global.server.Post(path: "Dashboard/NotificationRead/\(notific_id)", jsonObj: postdict, completionHandler: {
            (success,failure ,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["Message"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        defalts.setValue("\(indexpath.row)", forKey: "RemoveId")
                        self.show_popup(indexpath: indexpath,view: view)
                    }
                    else
                    {
                        self.alert(msgs:dict.value(forKey: "Message") as? String ?? "")
                    }
                }
            }
            else
            {
                self.alert(msgs: Global.network.redAlert(error: failure, noConnection: noConnection))
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.isHidden = true
        //self.removeAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        removeAnimate()
        //self.view.removeFromSuperview()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    
    func api(){
        //let jsonURL = "http://smartattend.colanonline.net/service/api/Dashboard/NotificationCountByDeviceID/131"
    let jsonURL = (BaseApi + "Dashboard/NotificationCountByDeviceID/" + account_id)
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
                    let myarray = json["LstNotificationDeviceModel"] as! NSArray
                    
                    for array in myarray
                    {
                        if let ar1 = array as? [String: Any]
                        {
                            print("In Json ID :",ar1["ID"] as! Int)
                            self.DeviceID.append(ar1["ID"] as! Int)
                            self.DeviceName.append(ar1["DeviceName"] as! String)
                            self.BtnColour.append(ar1["Color"] as! String)
                            self.DeviceMessage.append(ar1["Message"]as! String)
                            
                            print("In Json Device Name :",ar1["DeviceName"] as! String)
                        }
                    }
                    DispatchQueue.main.async
                        {
                            self.tblViewPopup.reloadData()
                    }
                }
                
            }
            catch {
                print("Error is : \n\(error)")
            }
            }.resume()
        
    }
    
  
    @objc func viewActionBtn(_ sender: UIButton) {
        let tag = sender.tag
        let indexpath = NSIndexPath(row: tag, section: 0)
        //self.post_notificinfo(indexpath:indexpath as IndexPath,view: tblViewPopup)
      

        
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
