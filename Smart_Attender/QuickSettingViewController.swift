//
//  QuickSettingViewController.swift
//  SA-ADMIN
//
//  Created by CIPL0590 on 09/07/19.
//  Copyright © 2019 Colan. All rights reserved.
//

import UIKit

class QuickSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet var tblView: UITableView!
    var QuickPopupData = [QuickRepData]()
    var responsearr:[String] = []
    var searchArr = [String]()
    var selectedRows:[IndexPath] = []
     var dataPopup = ["Description","ProductionHours","PartsProduced","AvgCycle","Target","NoOfIncidents"]
    
   // var userid: String = ""
    var descrip: Bool = false
    var prod: Bool = false
    var parts: Bool = false
    var avg: Bool = false
    var targe: Bool = false
    var noi: Bool = false
    var scra: Bool = false
    var totalCos: Bool = false
    var totalValu: Bool = false
    var userID:Int?
    //var createDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
   self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        reportSettingsGet()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPopup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuickPopUpTableViewCell", for: indexPath)as! QuickPopUpTableViewCell
        cell.dataLbl.text = dataPopup[indexPath.row]
        
        if indexPath.row == 0 {
            if self.descrip == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 1{
            if self.prod == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 2{
            if self.parts == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 3{
            if self.avg == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 4{
            if self.targe == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 5{
            if self.noi == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 6{
            if self.scra == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 7{
            if self.totalCos == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else if indexPath.row == 7{
            if self.totalValu == true{
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
            }else{
                
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        else{
            cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
        }
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? QuickPopUpTableViewCell else {
            return
        }
        
        
        
        
        if indexPath.row == 0 {
            if self.descrip == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 1 {
            if self.prod == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 2{
            if self.parts == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 3{
            if self.avg == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 4{
            if self.targe == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 5{
            if self.noi == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 6{
            if self.scra == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 7{
            if self.totalCos == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
        if indexPath.row == 8{
            if self.totalValu == true {
                cell.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                
            }else{
                cell.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    @objc func checkBoxSelection(_ sender:UIButton)
    {
        let position = sender.convert(sender.bounds.origin, to: self.tblView)
        let cellIndexPath = self.tblView.indexPathForRow(at: position)!
        
        let cell = tblView.cellForRow(at: cellIndexPath) as? QuickPopUpTableViewCell
        if sender.tag == 0 {
            if self.descrip == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.descrip = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.descrip = true
            }
            
            print(self.descrip)
            
        }
        if sender.tag == 1 {
            if self.prod == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.prod = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.prod = true
            }
            
        }
        
        if sender.tag == 2 {
            if self.parts == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.parts = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.parts = true
            }
            
        }
        if sender.tag == 3 {
            if self.avg == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.avg = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.avg = true
            }
            
        }
        if sender.tag == 4 {
            if self.targe == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.targe = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.targe = true
            }
            
        }
        if sender.tag == 5 {
            if self.noi == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.noi = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.noi = true
            }
            
        }
        if sender.tag == 6 {
            if self.scra == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.scra = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.scra = true
            }
            
        }
        if sender.tag == 7 {
            if self.totalCos == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.totalCos = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.totalCos = true
            }
            
        }
        if sender.tag == 8 {
            if self.totalValu == true {
                
                cell?.checkBtn.setImage(UIImage(named:"uncheckbox"), for: .normal)
                self.totalValu = false
                
            }else{
                cell?.checkBtn.setImage(UIImage(named:"bluechecked"), for: .normal)
                self.totalValu = true
            }
            
        }
        
        tblView.reloadData()
    }
    func reportSettingsGet() {
        let jsonURL = (BaseApi + "Part/QuickReportSetting/" + account_id)
         //let jsonURL = (BaseApi + "Dashboard/NotificationCountByDeviceID/" + account_id)
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard error == nil else{
                return
            }
            guard let dd = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                {
                    
                    let reportJson = json["QuickRepModel"] as! NSDictionary
                    
                    for (key, value) in reportJson {
                        self.responsearr.append("\(key) \(value)")
                    }
                    print(self.responsearr)
                    
                    self.descrip = reportJson["Description"] as! Bool
                    self.prod = reportJson["ProductionHours"] as! Bool
                    self.parts = reportJson["PartsProduced"] as! Bool
                    self.avg = reportJson["AvgCycle"] as! Bool
                    self.targe = reportJson["Target"] as! Bool
                    self.noi = reportJson["NoOfIncidents"] as! Bool
                   self.userID = reportJson["UserID"] as! Int
                    
                    print(reportJson)
                    
                    DispatchQueue.main.async
                        {
                            self.tblView.reloadData()
                    }
                }
            }
            catch {
                print("Error is : \n\(error)")
            }
            }.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func CloseBtnAction(_ sender: Any) {
        
        removeAnimate()
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.removeAnimate()

        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        startloader(msg: "Loading")
        let parameters = ["UserID": self.userID!, "Description": descrip, "ProductionHours" : prod, "PartsProduced": parts, "AvgCycle" : avg, "Target": targe,"NoOfIncidents": noi,"Scrap": scra,"TotalCost": totalCos,"TotalValue": totalValu,"CreatedDate": "2019-02-14T06:18:01.943"]
            
            
as [String : Any]
        print(parameters)
          //let jsonURL = (BaseApi + "Dashboard/NotificationCountByDeviceID/" + account_id)
        let url = URL(string: (BaseApi + "Part/SaveQuickReportSetting"))
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    self.stoploader()
                    self.removeAnimate()

                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
}
