//
//  UserListVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/10/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit

class UserListVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnAddNewUser: UIBarButtonItem!
    @IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    @IBOutlet weak var collectionUserlist: UICollectionView!
    
    var circleCount:CGFloat=2.0
    let reuseIdentifier = "UserListCollectionCell"
    var isIpadScreen:Bool!
    var arrayResponseList:[ArrayResponseList] = []
    var arrayAvatar = [String:UIImage]()
    var userListCount = 0
    var isFirstTimeLoaded:Bool!
    
    
    
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        callingViewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionUserlist.isHidden = true
        self.userListApi()
        
    }
    
    
    func callingViewDidload() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    
        
        
        toSetNavigationImagenTitle(titleString:"USER LISTS", isHamMenu: true)
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        
        
        if(Global.IS.IPAD || Global.IS.IPAD_PRO)
        {
            isIpadScreen = true
            circleCount = 3.0
        }
        self.collectionUserlist.isHidden = true
        
        
    }
    
    
    
    // MARK: - Local Methods
    func transitionChanges()
    {
        self.collectionUserlist?.collectionViewLayout.invalidateLayout()
        self.collectionUserlist.layoutIfNeeded()
        self.collectionUserlist.reloadData()
    }
    
    func getImage(imageUrlStr: String,indexpath: IndexPath) {
        var serverImage:UIImage = #imageLiteral(resourceName: "UserAvator")
        guard let imgURL = URL(string: imageUrlStr.replacingOccurrences(of: " ", with: "%20")) else { return self.arrayAvatar[imageUrlStr] = serverImage }
        let request:URLRequest = URLRequest.init(url: imgURL)
       
        let task = URLSession.shared.dataTask(with: request){
            data,response,error in
            guard let imgData = data
                else
            {
                print("Error \(error?.localizedDescription)")
                return
            }
            if  let image = UIImage(data: imgData) {
                serverImage = image
                self.arrayAvatar[imageUrlStr] = serverImage
                DispatchQueue.main.async {
                    
                    if let cell = self.collectionUserlist.cellForItem(at: indexpath) as? UserListCollectionCell
                    {
                        cell.imgProfile.contentMode = .scaleToFill
                        cell.imgProfile.image = serverImage
                    }
                }
            }
        }
        task.resume()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape
        {
            isIpadScreen = true
            circleCount = 3.0
            
        }
        else
        {
            isIpadScreen = false
            circleCount = 2.0
            if(Global.IS.IPAD || Global.IS.IPAD_PRO)
            {
                isIpadScreen = true
                circleCount = 3.0
            }
            
        }
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.transitionChanges()
        }, completion: nil)
    }
    
    
    func postDeleteUserApiAction(indexPath:Int) {
        print("Delete successfully")
        print("arrayResponseList-->>> \(arrayResponseList) arrayResponseList.count--->> \(arrayResponseList.count)")
        let deletedIndexPath = IndexPath(item: indexPath, section: 0)
        
        
        self.collectionUserlist.performBatchUpdates({
            self.arrayResponseList.remove(at: indexPath)
            self.userListCount = self.arrayResponseList.count
            self.collectionUserlist.deleteItems(at: [deletedIndexPath])
            
        }, completion: nil)
        
        
        print("arrayResponseList-->>> \(arrayResponseList) arrayResponseList.count--->> \(arrayResponseList.count)")
    }
    
    func animateCollectionview() {
        let cells = collectionUserlist.visibleCells
        for i in cells {
            let cell:UICollectionViewCell = i as UICollectionViewCell
           cell.transform = CGAffineTransform(scaleX: 0, y: 0)
            
        }
        var index = 0
        
        for a in cells {
            let cell: UICollectionViewCell = a as UICollectionViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: nil)
            
            index += 1
        }
    }
    
    // MARK: - Button Action
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        print("Add New user")
        
        let newUser = self.storyboard?.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        self.navigationController?.pushViewController(newUser, animated: true)
    }
    @IBAction func deleteUser(_ sender: UIButton) {
        self.alertOkCancel(msgs: "Are you sure you want to delete user", handlerCancel: {_ in
            print("NO") //NO
        }, handlerOk: {_ in
            print("Yes")
            let accountID = "\(self.arrayResponseList[sender.tag].accountID!)"
            print(accountID)
            self.deleteUserApi(indexPath:sender.tag,acoundID:accountID) //Yes
        })
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        var picDimension:CGFloat = (self.view.frame.size.width / circleCount) - 10
        
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular ) && (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
            picDimension = (self.view.frame.size.width / circleCount) - 13.5
        }
        
        return CGSize(width: picDimension,height: picDimension)
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UserListCollectionCell
        
        let dict = arrayResponseList[indexPath.row]
        cell.lblUserName.text = "\(dict.firstName ?? "") \(dict.lastName ?? "")"
        
        cell.imgProfile.image = #imageLiteral(resourceName: "user-1")
        if let imageStr = dict.imageURL,imageStr != ""
        {
            
            if let image = arrayAvatar[dict.imageURL!] {
                cell.imgProfile.image = image
            }
            else
            {
                
                self.getImage(imageUrlStr: imageStr,indexpath: indexPath)
            }
        }
        
        
        cell.cellTopView.backgroundColor = theme_color
        cell.layer.borderColor = theme_color.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.masksToBounds = true
        cell.btnDelete.tag = indexPath.item
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        
        },
                       completion: { finished in
        if Global.userType.isAdmin()  {
                for vc in (self.navigationController?.viewControllers)! {
                    if vc.isKind(of: UpdateUserVC.self){
                        return
                    }
                }
                            
                print("Collection View Did Select")
                let updateUser = self.storyboard?.instantiateViewController(withIdentifier: "UpdateUserVC") as! UpdateUserVC
                updateUser.userValues = [self.arrayResponseList[indexPath.row]]
                if let cell = collectionView.cellForItem(at: indexPath) as? UserListCollectionCell {
                    updateUser.passImage = cell.imgProfile.image
                }
                self.navigationController?.pushViewController(updateUser, animated: true)
                        }
                        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut,animations: {
                            cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                        },completion: nil)
                    })
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - GetAll DeviceList Method
    func userListApi()
    {
        if !ifLoading()
        {
            self.startloader(msg: "Loading.... ")
            
            Global.server.Get(path: "Account/UserList/\(customer_id!)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let userListModel = UserListModel.init(jsonData: success as AnyObject as AnyObject)
                    self.arrayResponseList.removeAll()
                    let dict:NSDictionary=success as! NSDictionary
                    if(userListModel.isSuccess != nil)
                    {
                        if (userListModel.isSuccess)!
                        {
                            print(dict)
                            self.arrayAvatar.removeAll()
                            self.userListCount = (userListModel.arrayResponseList?.count)!
                            for i in 0..<userListModel.arrayResponseList!.count {
                                self.arrayResponseList.append(ArrayResponseList.init(dict: userListModel.arrayResponseList![i]))
                            }
                            
                            if self.userListCount > 0 {
                                self.collectionUserlist.isHidden = false
                                self.collectionUserlist.reloadData()
                                self.collectionUserlist.layoutIfNeeded()
                                
                                self.animateCollectionview()
                            } else {
                                self.collectionUserlist.isHidden = true
                                self.showNodata(msgs: "Oops! There is no User list ")
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
        else
        {
            print("Already Loading")
        }
        
    }
    
    
    func deleteUserApi(indexPath:Int,acoundID:String)
    {
        self.startloader(msg: "Deleting.... ")
        Global.server.Get(path: "Account/DeleteAccount/\(acoundID)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
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
                                self.postDeleteUserApiAction(indexPath:indexPath)
                            })
                        }
                        else
                        {
                            
                            self.alert_handler(msgs: "Deleted Successfully", dismissed: {_ in
                                self.postDeleteUserApiAction(indexPath:indexPath)
                            })
                        }
                        
                    }
                    else
                    {
                        if(msgs.characters.count>0)
                        {
                            self.alert(msgs:(dict.value(forKey: "Message") as? String ?? ""))
                            
                        }
                        else
                        {
                            self.alert(msgs:"Unable to Delete user now")
                            
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
}


