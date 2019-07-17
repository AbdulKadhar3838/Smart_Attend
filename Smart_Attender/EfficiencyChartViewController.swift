//
//  EfficiencyChartViewController.swift
//  SA-ADMIN
//
//  Created by CIPL0453MOBILITY on 27/09/17.
//  Copyright © 2017 Colan. All rights reserved.
//

import UIKit
import Charts
import CoreMotion

class EfficiencyChartViewController: UIViewController{
     // MARK: - Initialization
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var btnDateRange: UIButton!
    @IBOutlet weak var btnBuild: UIButton!
    @IBOutlet weak var LineChart: LineChartView!
    @IBOutlet weak var imgvwLogo: UIImageView!
    
    
    var chartLegend:String=""
    var chartColor:String=""
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var tosetLandcaperightorleft = ""
    var tablevwDropDown: UITableView!
    var build_hours:Int!
    var arrayTimeDecimalXaxisData:[Double] = []
    var arrayResponseList:[ArrayQtyChart] = []
    var yAxisArray = Array<String>()
    var deviceId = ""
    
    
     // MARK: - Life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callingViewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(viewWillAppear)
        OrientationLock.motionCalculation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(viewDidAppear)
        if self.tablevwDropDown != nil {
        }
        else
        {
            self.dropdown()
        }
        
        appdelegate.shouldRotate = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        print(viewWillDisappear)

        motionManager.stopDeviceMotionUpdates()
        appdelegate.shouldRotate = true
        OrientationLock.topassLineorientationTopiechart(tosetLandcaperightorleft: tosetLandcaperightorleft)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .Linechart_Selectvalue, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Actions
    @IBAction func dropdown_button(_ sender: AnyObject?) {
        self.tablevwDropDown.isHidden=false
    }
    
     // MARK: - Local Method
    func callingViewDidload() {
        settingUI()
        
        lineChartApi()
    }
    
    func settingUI() {
        
        self.LineChart.delegate = self
        let screenTitle:String = defalts.value(forKey: "Device_Name") as? String ?? ""
        
        toSetNavigationImagenTitle(titleString:"\(screenTitle) - Target Analysis", isHamMenu: false) // Set title for Navigation Title

        self.lblPercentage.transform=CGAffineTransform(rotationAngle: -CGFloat.pi/2)
       // self.lblPercentage.frame.origin.x=3 // set Percentage lable align vertically to chart
        
        self.blueborder_dynamicradius(forview: self.btnBuild, radius: 4)
        self.anycolorborder(forview: self.btnDateRange, radius: 4,color: UIColor.lightGray)
        
        let tappinglogo: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.LogoClicked))
        tappinglogo.delegate=self
        self.imgvwLogo.addGestureRecognizer(tappinglogo)
        
        
        appdelegate.shouldRotate = false
        if tosetLandcaperightorleft == "HomeBtnright" {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else
        {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.linechartValueselected(notification:)), name: .Linechart_Selectvalue, object: nil)
        
        self.LineChart.isHidden = true
        self.btnBuild.isHidden = true
        
    }
    
    @objc func LogoClicked() {
        appdelegate.shouldRotate = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func chartDatainitialization() {
        chartColor = "#23238E"
        chartLegend = "Legend"
        yAxisArray = arrayResponseList.map({($0.value) ?? "0"})
        let xAxisArray = arrayResponseList.map({($0.period)})
        arrayTimeDecimalXaxisData = xAxisArray.map{self.convertdecimal(timestampString: $0 ?? "")}
        arrayglobalTimestampEfficiency = xAxisArray as! [String]
        countEffiAnimation = 0
        EfficiencyLineChart.plotLineChart(LineChart:LineChart,xAxisData: arrayTimeDecimalXaxisData, yAxisData: yAxisArray ,chartLegend:chartLegend,chartColor:chartColor)
    }
    
    /// Convert Time Stramp to Decimal Value
    func convertdecimal(timestampString: String) -> Double
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let since1970 = formatter.date(from: timestampString)?.timeIntervalSince1970
        return since1970 ?? 0
    }
    
    // MARK: - Drop Down Methods
    @objc func dismiss_dropdown() {
        if self.tablevwDropDown != nil
        {
            self.tablevwDropDown.isHidden=true
        }
    }
    @objc func show_dropdown() {
        if self.tablevwDropDown != nil
        {
            self.tablevwDropDown.isHidden=false
        }
    }
    func dropdown()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss_dropdown))
        tap.delegate=self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.tablevwDropDown = UITableView()
        self.tablevwDropDown.backgroundColor = UIColor.white
        self.tablevwDropDown.tableFooterView = UIView()
        self.tablevwDropDown.isHidden=true
        self.tablevwDropDown.register(UITableViewCell.self, forCellReuseIdentifier: "dropdown_cell")
        self.tablevwDropDown.delegate = self
        self.tablevwDropDown.dataSource = self
        self.tablevwDropDown.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(self.tablevwDropDown)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.show_dropdown))
        tap2.delegate=self
        tap2.cancelsTouchesInView = false
        self.tablevwDropDown.addGestureRecognizer(tap2)
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .top, relatedBy: .equal, toItem: self.btnDateRange, attribute: .bottom, multiplier: 1, constant: -2)
        
        let width_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.btnDateRange.frame.size.width)
        
        let height_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3*self.btnDateRange.frame.size.height)
        
        let centerhorizontally_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .centerX, relatedBy: .equal, toItem: self.btnDateRange, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width_constraint,height_constraint,top_constraint,centerhorizontally_constraint])
        self.anycolorborder(forview: self.tablevwDropDown, radius: 2,color: UIColor.lightGray)
    }
    
    // MARK: - Change Orientation
    override var shouldAutorotate : Bool {
        return false
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeRight]
    }
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    // MARK: - GetAll DeviceList Method
    func lineChartApi()
    {
        if !ifLoading()
        {
            self.startloader(msg: "Loading.... ")
            Global.server.Get(path: "EfficiencyMonitor/QtyPercentageChart/\(deviceId)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let efficiencyLineChartModel = EfficiencyLineChartModel.init(jsonData: success as AnyObject as AnyObject)
                    self.arrayResponseList.removeAll()
                    let dict:NSDictionary=success as! NSDictionary
                    if(efficiencyLineChartModel.isSuccess != nil)
                    {
                        if (efficiencyLineChartModel.isSuccess)!
                        {
                            print(dict)
                            for i in 0..<efficiencyLineChartModel.arrayQtyChart!.count {
                                self.arrayResponseList.append(ArrayQtyChart.init(dict: efficiencyLineChartModel.arrayQtyChart![i]))
                            }
                            if self.arrayResponseList.count > 0 {
                                self.LineChart.isHidden = false
                                self.lblPercentage.isHidden = false
                                self.lblPercentage.isHidden = false
                                self.chartDatainitialization()
                            } else {
                                self.LineChart.isHidden = true
                                self.showNodata(msgs: "Oops! There is no data")
                                self.lblPercentage.isHidden = true
                                self.lblPercentage.isHidden = true
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
}

    // MARK: - Delegate methods

extension EfficiencyChartViewController:
UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdown_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dropdown_cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = self.btnDateRange.titleLabel?.font
        cell.textLabel?.text = dropdown_array[indexPath.row]
        cell.textLabel?.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tablevwDropDown.isHidden = true
        btnDateRange.setTitle("  "+dropdown_array[indexPath.row], for: .normal)
        // build_hours=Int(indexPath.row)+1
        // defalts.setValue(build_hours, forKey: "hours_selected")
    }
    
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.btnDateRange.frame.size.height
    }
    
    // MARK: - Linechart protocol
    @objc func linechartValueselected(notification:Notification)
    {
        self.dismiss_dropdown()
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("Nothing Selected")
    }
  
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        countEffiAnimation = 1
        EfficiencyLineChart.plotLineChart(LineChart:LineChart,xAxisData: arrayTimeDecimalXaxisData, yAxisData: yAxisArray ,chartLegend:chartLegend,chartColor:chartColor)
    }
    
    
}


