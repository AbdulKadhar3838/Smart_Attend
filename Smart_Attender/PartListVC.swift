//
//  PartListVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 13/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class PartListVC: UIViewController{
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var tablePartList: UITableView!
    
    var createPartListModel = CreatePartListModel()
    var isFirstTimeLoaded:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        callingViewDidload()
    }
    override func viewWillAppear(_ animated: Bool) {
        partListApi()
        isFirstTimeLoaded = true
    }
    
    // MARK: - Local Declaration
    func callingViewDidload() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        toSetNavigationImagenTitle(titleString:"Part Number Database", isHamMenu: true)
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        tablePartList.tableFooterView = UIView(frame: CGRect.zero)
        
        
        tablePartList.separatorInset = UIEdgeInsets.zero
        tablePartList.layoutMargins = UIEdgeInsets.zero
        tablePartList.delegate  = self
        tablePartList.dataSource = self
         // List Api
    }
    
    func animateTableview() {
        let cells = tablePartList.visibleCells
        let tableHeight:CGFloat = tablePartList.bounds.size.height
        
        for i in cells {
            let cell:UITableViewCell = i as UITableViewCell
           cell.transform = CGAffineTransform(translationX: 0, y: tableHeight).concatenating(CGAffineTransform(scaleX: 0.001, y: 0.001)).concatenating(CGAffineTransform(rotationAngle: -CGFloat.pi))
            
//            cell.transform = CGAffineTransform(scaleX: 0.001, y: 0.001).concatenating(CGAffineTransform(rotationAngle: -CGFloat.pi)).concatenating(CGAffineTransform(translationX: 0, y: -tableHeight))
            
        }
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(CGAffineTransform(scaleX: 1, y: 1)).concatenating(CGAffineTransform(rotationAngle: 0))
//                cell.transform = (CGAffineTransform(scaleX: 1, y: 1)).concatenating(CGAffineTransform(rotationAngle: 0)).concatenating(CGAffineTransform(translationX: 0, y: 0))
               
            }, completion: nil)
            
            index += 1
        }
    }
    // MARK: - Button Action
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    
    @IBAction func addPart(_ sender: UIBarButtonItem) {
        let newPart = self.storyboard?.instantiateViewController(withIdentifier: "CreatePartListVC") as! CreatePartListVC
        newPart.passTitle = "Add Part"
        newPart.isAddPart = true
        self.navigationController?.pushViewController(newPart, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - GetAll DeviceList Method
    func partListApi()
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/PartMasterList/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                if let dict = success as? [String : AnyObject] {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    if (success)
                    {
                        self.createPartListModel.arrayList?.removeAll()
                        self.createPartListModel =  CreatePartListModel.valueInitialization(jsonData: dict)
                        
                        if let array = self.createPartListModel.arrayList{
                            if array.count > 0 {
                                
                                self.tablePartList.isHidden = false
                                self.tablePartList.reloadData()
                                if self.isFirstTimeLoaded {
                                    self.isFirstTimeLoaded = false
                                    self.animateTableview()
                                }
                            } else {
                                self.tablePartList.isHidden = true
                                self.showNodata(msgs: "Oops! There is no data in Schedule")
                            }
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
    
    // MARK: - Remove Get Api
    func partRemoveApi(PartID:String)
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "Part/RemovePartMaster/\(PartID)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict = success as! [String : AnyObject]
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    let msgs:String = dict["Message"] as? String ?? ""
                    if (success)
                    {
                        
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = (dict["Message"] as? String ?? "")
                            
                        }
                        else
                        {
                            message = "Part Removed Succesfully"
                            
                        }
                        self.alert_handler(msgs: message, dismissed: {_ in
                            self.postApiAction()
                        })
                        
                    } else {
                        var message:String = ""
                        if(msgs.characters.count>0)
                        {
                            message = dict["Message"] as? String ?? ""
                        }
                        else
                        {
                            message = "Unable to remove now"
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
    
    func postApiAction() {
     partListApi()
        
    }
    
    
}
extension PartListVC:UITableViewDelegate,UITableViewDataSource {
    // MARK: - Tableview Protocol methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let array =  createPartListModel.arrayList {
            return array.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CreatePartListTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CreatePartListTableCell
        for case let lbl as UILabel in cell.contentView.subviews {
            lbl.text = ""
        }
        
        if let array = createPartListModel.arrayList{
            cell.lblGroupId.text = array[indexPath.row].groupID
            cell.lblPartNo.text = array[indexPath.row].partNo
            print( array[indexPath.row].partNo)
            cell.lblCavity.text = "\(array[indexPath.row].cavity ?? 0)"
            cell.lblCycleTime.text = array[indexPath.row].cycleTime
            cell.lblDescription.text = array[indexPath.row].description
        }
        
        cell.btnSpacer.setImage(#imageLiteral(resourceName: "SA-1"), for: .normal)
        cell.contentView.backgroundColor = UIColor.white
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CreatePartListTableCell") as! CreatePartListTableCell
        
        
        headerCell.contentView.backgroundColor = theme_color
        for case let lbl as UILabel in headerCell.contentView.subviews {
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            if Global.IS.IPAD || Global.IS.IPAD_PRO {
                lbl.font = UIFont.systemFont(ofSize: 20)
            } else {
                lbl.font = UIFont.systemFont(ofSize: 11)
            }
        }
       
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(editingStyle.rawValue)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            // Remove item at indexPath
           
            
            if let array = self.createPartListModel.arrayList {
               // self.partRemoveApi(PartID:  "\(array[indexPath.row].partID ?? 0)")
                 print("remove part")
                let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                // create an action
                let firstAction: UIAlertAction = UIAlertAction(title: "Do you want remove Part", style: .default) { action -> Void in
                    self.partRemoveApi(PartID:  "\(array[indexPath.row].partID ?? 0)")
                    print("First Action pressed")
                }
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
                
                // add actions
                actionSheetController.addAction(firstAction)
                actionSheetController.addAction(cancelAction)
                
                self.present(actionSheetController, animated: true, completion: nil)
            
            }
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // Edit item at indexPath
            
            let newPart = self.storyboard?.instantiateViewController(withIdentifier: "CreatePartListVC") as! CreatePartListVC
            newPart.passTitle = "Update Part"
            newPart.isAddPart = false
            if let array = self.createPartListModel.arrayList {
                newPart.passPartNo = array[indexPath.row].partNo ?? ""
                newPart.passGroupID = array[indexPath.row].groupID ?? ""
                newPart.passCavity = "\(array[indexPath.row].cavity ?? 0)"
                newPart.passCycleTime = array[indexPath.row].cycleTime ?? ""
                newPart.passDescription = array[indexPath.row].description ?? ""
                newPart.passPartID = array[indexPath.row].partID ?? 0
            }
            self.navigationController?.pushViewController(newPart, animated: true)
        }
        
        remove.backgroundColor = UIColor.init(netHex_String: "#e74c3c")
        edit.backgroundColor = UIColor.init(netHex_String: "#e67e22")
        return [remove, edit]
        
    }
}

