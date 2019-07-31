//
//  QuickReportVC.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 07/12/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts

class QuickReportVC: UIViewController,UITextFieldDelegate,ChartViewDelegate {
    
@IBOutlet weak var slidemenu_barbtn: UIBarButtonItem!
    
    
    @IBOutlet weak var viewSearchBG: UIView!
    @IBOutlet weak var txtfdFromDate: UITextField!
    @IBOutlet weak var txtfdDropDown: UITextField!
    @IBOutlet weak var txtfdToDate: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var scrollParent: UIScrollView!
    @IBOutlet weak var tableList: UITableView!
    var headerCell:QuickReportHeaderCell?

    var arrayPicker:[String] = []
    var arrayDeviceID:[Int64] = []
    var pickerView = UIPickerView()
    var fromDate = Date()
    var toDate = Date()
    var isFromDate:Bool = false
    var deviceID:Int64 = 0
    var quickReportListModel = QuickReportListModel()
    var quickReportChartModel = QuickReportChartModel()
    var isFirstTimeToDate:Bool = true
    var workValue = 0
    var stressValue = 0
    var relaxValue = 0
    var sleepValue = 0
    
    //Pop up
    
    @IBOutlet weak var btnClosePopUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tablePiechart: UITableView!
    @IBOutlet weak var piechartView: PieChartView!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var lblPopupBG: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callingViewDidload()
        
        let logoBtn = UIButton(type: UIButton.ButtonType.custom)
        logoBtn.setImage(UIImage(named: "Dashboard"), for: .normal)
        logoBtn.addTarget(self, action: #selector(self.logoClicked) , for: .touchUpInside)
        logoBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        let button2 = UIButton(type: .custom)
        button2.setImage(UIImage (named: "settingsbig"), for: .normal)
        button2.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button2.addTarget(self, action: #selector(self.logoClickedSettings), for: .touchUpInside)
        
        let barButtonItem2 = UIBarButtonItem(customView: button2)
        self.navigationItem.rightBarButtonItems = [barButton, barButtonItem2]
      
        
    }
    
    func callingViewDidload() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        toSetNavigationImagenTitle(titleString:"Quick Report", isHamMenu: true)
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        navigationItem.backBarButtonItem = barButton
        
        if revealViewController() != nil {
            slidemenu_barbtn.target = revealViewController()
            slidemenu_barbtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 280
            revealViewController().tapGestureRecognizer()
        }
        
        piechartView.delegate = self
        scrollParent.delegate = self
        pickerView.delegate = self
        txtfdFromDate.delegate = self
        txtfdToDate.delegate = self
        tableList.alwaysBounceVertical = false
        tableList.alwaysBounceHorizontal = false
        scrollParent.scrollsToTop = true
        scrollParent.isDirectionalLockEnabled = true
        scrollParent.contentSize = CGSize(width: scrollParent.contentSize.width, height: 0)
        
        
        arrayPicker = arrayGlobalMachineName
        arrayPicker.insert("--Select--", at: 0)
        arrayPicker.insert("All machines", at: 1)
        arrayDeviceID = arrayGlobalDeviceIDwtfMachineName
        arrayDeviceID.insert(0, at: 0)
        arrayDeviceID.insert(0, at: 1)
        tableList.isHidden = true
        
        txtfdDropDown.inputView = pickerView
        
        viewPopUp.layer.cornerRadius = 8
        viewPopUp.layer.masksToBounds = true
        tableList.separatorInset = UIEdgeInsets.zero
        tableList.layoutMargins = UIEdgeInsets.zero
        tableList.tableFooterView = UIView(frame: CGRect.zero)
        tableList.decelerationRate = UIScrollViewDecelerationRateFast
        
        
        
        addDoneButtonOnKeyboard(txtfd: txtfdDropDown, selector: #selector(doneButtonMachineName),title: "Next")
        addDoneButtonOnKeyboard(txtfd: txtfdFromDate, selector: #selector(doneButtonFromDate),title: "Next")
        addDoneButtonOnKeyboard(txtfd: txtfdToDate, selector: #selector(doneButtonToDate),title: "Done")
        
        self.txtfdFromDate.addSubview(self.leftviewTwo(fortextfield: self.txtfdFromDate,imagename: "calendar-1"))
        self.txtfdToDate.addSubview(self.leftviewTwo(fortextfield: self.txtfdToDate,imagename: "calendar-1"))
        self.txtfdDropDown.addSubview(self.rightViewTwo(fortextfield: self.txtfdDropDown,imagename: "Tick"))
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewSearchBG.layer.cornerRadius = 0.5 * viewSearchBG.frame.size.height
        viewSearchBG.layer.masksToBounds = true
        btnSearch.layer.cornerRadius = 0.5 * btnSearch.frame.size.height
        btnSearch.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Actions
    @IBAction func logoButtonImage(_ sender: Any) {
        self.pushDesiredVC(identifier: "dashboard2_ViewController")
    }
    
    @IBAction func searchList(_ sender: UIButton) {
        if txtfdDropDown.text == nil || txtfdDropDown.text == "" || txtfdDropDown.text == "--Select--" {
        
            alert(msgs: "Fill the Device Name")
            txtfdDropDown.becomeFirstResponder()
            
        } else if txtfdFromDate.text == nil || txtfdFromDate.text == "" {
            
            alert(msgs: "Fill the Start Date")
            txtfdFromDate.becomeFirstResponder()
        } else if txtfdToDate.text == nil || txtfdToDate.text == "" {
            
            alert(msgs: "Fill the To Date")
            txtfdToDate.becomeFirstResponder()
        } else if toDate < fromDate{
            alert(msgs: "Fill the ToDate greater than start date")
            txtfdToDate.becomeFirstResponder()
        } else {
                 let pathString = "Dashboard/ReportDate?CustomerID=\(customer_id!)&DeviceID=\(deviceID)&FromDate=\(txtfdFromDate.text ?? "" )&ToDate=\(txtfdToDate.text ?? "")"
                if  let path = pathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed )?.replacingOccurrences(of: "+0000", with: "") {
                    
                    quickReportListApi(path:path)
                
                }
            
        }
    }
    
    //Click button(incident) in listTable
    @IBAction func incidentChart(_ sender: UIButton) {
        if let array = quickReportListModel.arrayList {
            self.lblTitle.text = array[sender.tag].machineName ?? ""
            if let machineDeviceid = array[sender.tag].deviceID, let fromDate = array[sender.tag].incidentStartDate ,fromDate != "", let toDate = array[sender.tag].incidentEndDate,toDate != "" {
                let pathString = "Dashboard/IncidentChart?DeviceID=\(machineDeviceid)&FromDate=\(fromDate)&ToDate=\(toDate)"
                if  let path = pathString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed )?.replacingOccurrences(of: "+0000", with: "") {
                    
                    chartApi(path:path)
                    
                }
            }
        }

    }
    
    @IBAction func closePopUPView(_ sender: UIButton) {
        viewPopUp.isHidden = true
        lblPopupBG.isHidden = true
    }
    
    func chartDataInterpreatation() {
        
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            self.viewPopUp.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if let array = quickReportChartModel.arrayChartDataList {
            
            if let yValues = array.map({($0.value)}) as? [String],let colors = array.map({$0.color}) as? [String]{
               PiechartModel.plotPieChart(piechart: self.piechartView, yValues: yValues.map({Double($0) ?? 0}), arrayColor: colors.map({UIColor.init(netHex_String: $0)}))
                
        }
        
        }
    }
    
    // MARK: - Textfield Action & Methods
    @IBAction func settingFromDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        datePickerView.minuteInterval = 60
        
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(self.datePickerFromValueChanged), for: UIControlEvents.allEvents)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        txtfdFromDate.text = dateFormatter.string(from: sender.date)
        fromDate = sender.date
        isFromDate = true
    }
    
    @IBAction func settingToDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.minuteInterval = 60
        datePickerView.datePickerMode = .dateAndTime
        if isFromDate {
            datePickerView.minimumDate = fromDate
        }
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
//        if isFirstTimeToDate {
//            txtfdToDate.text = dateFormatter.string(from: Date())
//            isFirstTimeToDate = false
//        }
        
        datePickerView.addTarget(self, action: #selector(self.datePickerToValueChanged), for: UIControlEvents.allEvents)
    }
    
    @objc func datePickerToValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        txtfdToDate.text = dateFormatter.string(from: sender.date)
        toDate = sender.date
    }
    func addDoneButtonOnKeyboard(txtfd:UITextField,selector:Selector,title:String)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: title, style:.plain, target: self, action: selector)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        txtfd.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonMachineName(sender:UITextField)
    {
        self.txtfdFromDate.becomeFirstResponder()
    }
    
    @objc func doneButtonFromDate()
    {
        self.txtfdToDate.becomeFirstResponder()
    }
    
    @objc func doneButtonToDate()
    {
        dismissKeyboard()
        scrollParentScrollview(xPosition:self.view.frame.size.width*(1.7) )
    }
    
    func scrollParentScrollview(xPosition:CGFloat) {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
            self.scrollParent.contentOffset = CGPoint(x: xPosition, y: -64)
        }, completion: nil)
    }
    // MARK: - GetAll Quick Report List Method
    func quickReportListApi(path:String)
    {
        
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: path, jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                if let dict = success as? [String : AnyObject] {
                if(dict["IsSuccess"] != nil)
                {
                    let success = dict["IsSuccess"] as? Bool ?? false
                    if (success)
                    {
                        self.quickReportListModel.arrayList?.removeAll()
                        self.quickReportListModel = QuickReportListModel.valueInitialization(jsonData: dict)
                        
                       if let array = self.quickReportListModel.arrayList{
                            if array.count > 0 {
                                self.tableList.isHidden = false
                                self.tableList.reloadData()
                            
                            } else {
                                self.tableList.isHidden = true
                                self.showNodata(msgs: "No Record Found")
                            }
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
    
    // MARK: - GetAll Chart List Method
    func chartApi(path:String)
    {
        
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: path, jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                if let dict = success as? [String : AnyObject] {
                    if(dict["IsSuccess"] != nil)
                    {
                        let success = dict["IsSuccess"] as? Bool ?? false
                        if (success)
                        {
                            self.quickReportChartModel.arrayChartDataList?.removeAll()
                            self.quickReportChartModel.arrayChartTableList?.removeAll()
                            self.quickReportChartModel = QuickReportChartModel.valueInitialization(jsonData: dict)

                            if let array = self.quickReportChartModel.arrayChartDataList{
                                if array.count > 0 {
                                    self.viewPopUp.isHidden = false
                                    self.lblPopupBG.isHidden = false
                                    self.chartDataInterpreatation()
                                    self.tablePiechart.reloadData()

                                } else {
                                    self.viewPopUp.isHidden = true
                                    self.lblPopupBG.isHidden = true
                                    self.alert(msgs: "No Record Found")
                                }
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
    
    // MARK: - Chart Delegate methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected")
        if let array = quickReportChartModel.arrayChartDataList {
        print(highlight)
            piechartView.centerText = "\(array[Int(entry.x)].label ?? "") \n \(entry.y)"
        }
        
        
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
        piechartView.centerText = ""
    }
    
}

extension QuickReportVC: UITableViewDelegate,UITableViewDataSource {
    // MARK: - Tableview Protocol methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if tableView == tableList {
        if let array = quickReportListModel.arrayList {
            return array.count
        } else {
            return 0
        }
        } else {
            if let array = quickReportChartModel.arrayChartTableList {
                return array.count
            } else {
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableList {
        let cellIdentifier1 = "QuickReportListCell"
        let cellIdentifier2 = "QuickReportHeaderCell"
        let cell1 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier1, for: indexPath) as! QuickReportListCell
        //let cell2 = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath) as! QuickReportHeaderCell
            
        if let array = quickReportListModel.arrayList{
            if  let machineName = array[indexPath.row].machineName {
                print(machineName)
                cell1.lblMachineName.text = machineName //yes
            }
            if  let partNo = array[indexPath.row].partNo {
                cell1.lblPartNo.text = partNo           //yes
            }
            if  let description = array[indexPath.row].description {
                cell1.lblDescription.text = description  //yes
            }
            if  let startDate = array[indexPath.row].startDate {
                cell1.lblStartDate.text = startDate     //yes
            }
            if  let endDate = array[indexPath.row].endDate {
                cell1.lblEnddate.text = endDate         //yes
            }
            
            if  let producedHrs = array[indexPath.row].producedHrs,let duration = array[indexPath.row].duration {
                cell1.lblProductionHrs.text = "\(duration)/\(producedHrs)" // yes
            }
            
            if  let partsProduced = array[indexPath.row].partsProduced,let expected = array[indexPath.row].expectedProduced,let incidents = array[indexPath.row].incidents {
               if expected == 0 && partsProduced == 0 && incidents == 0{
                headerCell!.btnPartsProduced.isHidden = true
                
                }
                cell1.lblPartsProduced.text = "\(partsProduced)/\(expected)"
            }
            if  let avgCycle = array[indexPath.row].avgCycle ,let cycle = array[indexPath.row].cycleTime{
                cell1.lblAvgCycle.text = "\(avgCycle)/\(cycle)"
            }
            if  let OEE = array[indexPath.row].OEE {
                cell1.lblOEE.text = "\(OEE)%"
            }
            if  let incidents = array[indexPath.row].incidents {
                cell1.btnIncident.setTitle("\(incidents)", for: .normal)
            }
            
            if  let scarp = array[indexPath.row].scrap {
                if scarp == 0 {
                    headerCell?.btnScarp.isHidden = true
                }
                cell1.lblScarp.text = "\(scarp)"
            }
            if  let totalValue = array[indexPath.row].totalValue {
                cell1.lblTotalValue.text = "\(totalValue)"
            }
            if  let totalCost = array[indexPath.row].totalCost {
                cell1.lblTotalCost.text = "\(totalCost)"
            }
            
            
        }
        cell1.btnIncident.tag = indexPath.row
        cell1.layoutMargins = UIEdgeInsets.zero
        return cell1
        } else {
            let cellIdentifier = "QuickReportChartTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuickReportChartTableCell
            if let array = quickReportChartModel.arrayChartTableList{
                if  let name = array[indexPath.row].inputNmae {
                    cell.lblName.text = name
                }
                if  let incident = array[indexPath.row].incident {
                    cell.lblIncident.text = "\(incident)"
                }
                if  let color = array[indexPath.row].label as? String ,color != ""{
                    cell.lblBox.backgroundColor = UIColor.init(netHex_String: color)
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("Did Select")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
      if  tableView == tableList {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "QuickReportHeaderCell")
        
        return headerCell
      } else {
        return UIView(frame: CGRect.zero)
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       if tableView == tableList {
           return 50
       } else {
        return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
extension QuickReportVC: UIScrollViewDelegate{
    // MARK: - Scrollview Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       //  print("this is scrollViewDidScroll")
        
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
       // print("this is calling scrollViewDidEndScrollingAnimation")
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       // print("this is calling scrollViewWillEndDragging")
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("this is calling scrollViewDidEndDragging")
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableList {
            // tableList.isScrollEnabled = false
          //  print("this is calling scrollViewWillBeginDecelerating")
           // tableList.decelerationRate = UIScrollViewDecelerationRateFast
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableList {
            // tableList.isScrollEnabled = true
          //  print("this is calling scrollViewDidEndDecelerating")
            
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      //  print( "scrollView.contentOffset.x=\(scrollView.contentOffset.x)")
      //  print( "scrollView.contentOffset.y=\(scrollView.contentOffset.y)")
        
        if scrollView == scrollParent {
       //     print("Scroll Will Begin Dragging scrollParent")
        } else {
            
          //  print("Scroll Will Begin Dragging tablelist")
        }
        
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.x > 0){
            // Dragging right
           // print("Dragging right")
        }
        if actualPosition.x < 0{
            // Dragging left
          //  print("Dragging left")
        }
        if (actualPosition.y > 0){
            // Dragging down
           // print("Dragging down")
        }
        if (actualPosition.y < 0){
            // Dragging up
           // print("Dragging up")
        }
        if actualPosition.x == 0 && actualPosition.y == 0 {
         //   print("My conflict Dragging")
            
            
        }
    }
}
extension QuickReportVC:UIPickerViewDelegate,UIPickerViewDataSource {
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
        txtfdDropDown.text = arrayPicker[row]
        deviceID = arrayDeviceID[row]
    }
}

