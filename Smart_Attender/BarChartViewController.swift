
//  Created by Rajith Kumar on 27/09/17.

import UIKit
import Charts
import CoreMotion

class BarChartViewController: UIViewController{
    // MARK: - Initialization
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var imgvwLogo: UIImageView!
    
    @IBOutlet weak var btnrange: UIButton!
    @IBOutlet weak var btnBuild: UIButton!
    
    var arrayResponseList:[ArrayBarChart] = []
    var deviceId = ""
    
    var arrayColorActualETA:[UIColor] = []
    let arrayColorETA:[UIColor] = [UIColor.init(netHex_String: "#65BD77")]
    var arrayActualETA:[Double] = []
    var arrayETA:[Double] = []
    var deviceStartTime = ""
    var deviceEndTime = ""
    var etaTotalHrsStr = ""
    
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var tosetLandcaperightorleft = ""
    var tablevwDropDown: UITableView!
    var build_hours:Int!

    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barChart.delegate = self
        callingViewDidload()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Local Function
    func callingViewDidload() {
        self.settingUI()
        
        self.BarChartApi()
        
    }
    
    func settingUI() {
        
        
        let screenTitle:String = defalts.value(forKey: "Device_Name") as! String
       
        toSetNavigationImagenTitle(titleString:"\(screenTitle) - Timeline Analysis", isHamMenu: false)  // Set title for Navigation Title
        self.blueborder_dynamicradius(forview: self.btnBuild, radius: 4)
        self.anycolorborder(forview: self.btnrange, radius: 4,color: UIColor.lightGray)
        
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
        
        self.barChart.isHidden = true
    }
    
    @objc func LogoClicked() {
        appdelegate.shouldRotate = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    /// Chart Y axis Values Generation and converstion
    func valuesForChart() {
        
        arrayColorActualETA = arrayResponseList.map({UIColor.init(netHex_String: $0.color!)})
        arrayETA = [convertdecimal(fromDate: deviceStartTime, toDate: deviceEndTime)]
        arrayActualETA = arrayResponseList.map({convertdecimal(fromDate: $0.startDate!, toDate: $0.endDate!)})
        print(arrayActualETA)
        
        //For Ballon Marker
        arrayglobalTimestampActual = arrayResponseList.map({$0.totalHours!})
        arrayglobalETCTask = arrayResponseList.map({$0.task!})
        
        // Need to fill data if both ETA & ActualETA Start date isn't same (Dummy)
        if arrayResponseList[0].startDate != deviceStartTime {
            arrayglobalTimestampActual.insert("", at: 0)
            arrayglobalETCTask.insert("", at: 0)
            arrayColorActualETA.insert(.clear, at: 0)
            arrayActualETA.insert(convertdecimal(fromDate: deviceStartTime, toDate: arrayResponseList[0].startDate!), at: 0)
            isStartDateSame = false
            
        } 
        arrayglobalTimestampETA = [etaTotalHrsStr]
        
        countBarAnimation = 0 // Chart Animation Turn On When count = 0
        
        
        StackedBarHorizontalChart.plotChart(barChart: barChart, colorActualETA:  arrayColorActualETA,colorETA: arrayColorETA , yValuesETA: arrayETA , yValuesActualETA: arrayActualETA,baseDate:deviceStartTime)
    }
    
    /// Convert Time Stramp to Decimal Value
    func convertdecimal(fromDate: String,toDate: String) -> Double
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let baseDate:Date = formatter.date(from: fromDate)!
        let since1970 = formatter.date(from: toDate)?.timeIntervalSince(baseDate)
        return since1970!
    }

    
    // MARK: - Buttton Actions
    @IBAction func buildChart(_ sender: Any) {
        print("inside Build")
        countBarAnimation = 0 // Chart Animation Turn On When count = 0
    }
    @IBAction func dropdown_button(_ sender: AnyObject?) {
        self.tablevwDropDown.isHidden=false
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
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .top, relatedBy: .equal, toItem: self.btnrange, attribute: .bottom, multiplier: 1, constant: -2)
        
        let width_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.btnrange.frame.size.width)
        
        let height_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3*self.btnrange.frame.size.height)
        
        let centerhorizontally_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.tablevwDropDown, attribute: .centerX, relatedBy: .equal, toItem: self.btnrange, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width_constraint,height_constraint,top_constraint,centerhorizontally_constraint])
        self.anycolorborder(forview: self.tablevwDropDown, radius: 2,color: UIColor.lightGray)
    }
    
    // MARK: - GetAll DeviceList Method
    // TODO: - Need to pass data Chart
    func BarChartApi()
    {
        if !ifLoading()
        {
            self.startloader(msg: "Loading.... ")
            Global.server.Get(path: "EfficiencyMonitor/BarChart/\(deviceId)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
                self.stoploader()
                if(failure == nil && noConnection == nil)
                {
                    let efficiencyBarChartModel = BarChartModel.init(jsonData: success as AnyObject as AnyObject)
                    self.arrayResponseList.removeAll()
                    let dict:NSDictionary=success as! NSDictionary
                    if(efficiencyBarChartModel.isSuccess != nil)
                    {
                        if (efficiencyBarChartModel.isSuccess)!
                        {
                            print(dict)
                            if let startTime = efficiencyBarChartModel.deviceStartTime {
                                self.deviceStartTime = startTime
                            }
                            if let endTime = efficiencyBarChartModel.deviceEndTime {
                                self.deviceEndTime = endTime
                            }
                            if let etaTotalHrs = efficiencyBarChartModel.etaTotalHours {
                                self.etaTotalHrsStr = etaTotalHrs
                            }
                            
                            for i in 0..<efficiencyBarChartModel.arrayBarChart!.count {
                                self.arrayResponseList.append(ArrayBarChart.init(dict: efficiencyBarChartModel.arrayBarChart![i]))
                            }
                            
                            if self.arrayResponseList.count > 0 && self.deviceStartTime != "" && self.deviceEndTime != "" {
                                self.barChart.isHidden = false
                                self.valuesForChart()
                            } else {
                                
                                self.barChart.isHidden = true
                                self.showNodata(msgs: "Oops! There was no data")
                                
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

 // MARK: - Delegate Methods
extension BarChartViewController: UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdown_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dropdown_cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = self.btnrange.titleLabel?.font
        cell.textLabel?.text = dropdown_array[indexPath.row]
        cell.textLabel?.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tablevwDropDown.isHidden = true
        btnrange.setTitle("  "+dropdown_array[indexPath.row], for: .normal)
        // build_hours=Int(indexPath.row)+1
        // defalts.setValue(build_hours, forKey: "hours_selected")
    }
    
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.btnrange.frame.size.height
    }
    
    // MARK: - Chart Delegate Method
    @objc func linechartValueselected(notification:Notification)
    {
        self.dismiss_dropdown()
    }
    func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("Nothing Selected")
    }
    
    public  func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        countBarAnimation = 1
        StackedBarHorizontalChart.plotChart(barChart: barChart, colorActualETA:  arrayColorActualETA,colorETA: arrayColorETA , yValuesETA: arrayETA as! [Double], yValuesActualETA: arrayActualETA,baseDate:deviceStartTime)
    }
}





    





