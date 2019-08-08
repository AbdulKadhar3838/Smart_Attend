
import UIKit
import Charts
import CoreMotion

class HighLowGraphView: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate  {
    // MARK: - Connected Outlets
    @IBOutlet weak var linechart_view: LineChartView!
    @IBOutlet weak var date_rangebtn: UIButton!
    @IBOutlet weak var logo_imageview: UIImageView!
    @IBOutlet weak var build_Button: UIButton!
    // MARK: - Variables
    var linechart_array:NSMutableArray=[]
    var dropdown_tableview: UITableView!
    var xchart_array:NSMutableArray=[]
    var ychart_array:NSMutableArray=[]
    var device_id:String=""
    var chart_color:String=""
    var chart_legend:String=""
    var chart_index:String=""
    var build_hours:Int!
   // var piepassingforHighLowOrientation = ""
    var pitchCalculation:Double!
    var yawCalculation:Double!
    var rollCalculation:Double!
    var tosetLandcaperightorleft = ""
    
    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        defalts.setValue("HighLow", forKey: "GraphType")
        defalts.synchronize()
        self.linechart_view.noDataText = ""
        self.blueborder_dynamicradius(forview: self.build_Button, radius: 4)
        self.anycolorborder(forview: self.date_rangebtn, radius: 4,color: UIColor.lightGray)
        let screenTitle:String = defalts.value(forKey: "Device_Name") as? String ?? ""
        toSetNavigationImagenTitle(titleString:"\(screenTitle) - Input Analysis", isHamMenu: false)
        
        self.linechart_view.isHidden=true
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        if tosetLandcaperightorleft == "HomeBtnright" {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else
        {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        self.date_rangebtn.setTitle("  "+dropdown_array[self.getSelectedHours()-1], for: .normal)
        self.build_hours=self.getSelectedHours()
        self.linechart_view.delegate=self
        self.linechart_data(forhours: self.getSelectedHours())
        NotificationCenter.default.addObserver(self, selector: #selector(self.linechartValueselected(notification:)), name: .Linechart_Selectvalue, object: nil)
       
        let taplogo: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.Logo_Clicked))
        taplogo.delegate=self
        self.logo_imageview.addGestureRecognizer(taplogo)
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .Linechart_Selectvalue, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func linechart_data(forhours: Int)
    {
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "EfficiencyMonitor/LineOnOffChart/\(device_id)/\(forhours)/\(chart_index)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as? Bool ?? false
                    if (success)
                    {
                        self.linechart_array.removeAllObjects()
                        let data:NSArray = dict.value(forKey: "LineChart") as? NSArray ?? []
                        self.linechart_array = data.mutableCopy() as! NSMutableArray
                        print(self.linechart_array.count)
                        
                        self.xchart_array.removeAllObjects()
                        self.ychart_array.removeAllObjects()
                        for i in 0..<self.linechart_array.count
                        {
                            let temp:NSDictionary=self.linechart_array[i] as! NSDictionary
                            let decimal_time:Double=self.convert_decimal(dict: temp)
                            self.xchart_array.add(decimal_time)
                            let xval:Double=(temp.value(forKey: "y") as? Double)!
                            self.ychart_array.add(xval)
                        }
                       
                        if (self.linechart_array.count>0)
                        {
                            self.linechart_view.isHidden=false
                            countEffiAnimation = 0
                            self.setChart(dataPoints: self.xchart_array, data1: self.ychart_array)
                        }
                        else
                        {
                            self.linechart_view.isHidden=true
                            self.showNodata(msgs: "No Records Found. Try Again.")
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        motionCalculation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.dropdown_tableview != nil {
        }
        else
        {
            self.dropdown()
        }
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
          motionManager.stopDeviceMotionUpdates()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        topassLineorientationTopiechart()
    }
    
    //MARK:- LineChart
    func setChart(dataPoints: NSMutableArray, data1: NSMutableArray)
    {
        let xaxis:XAxis = XAxis()
        let xAxisFormatter:xAxisOnOffFormatter = xAxisOnOffFormatter()
        let LeftAxisFormatter:LeftAxisOnOffFormatter = LeftAxisOnOffFormatter()
        let yaxis:YAxis = YAxis()
       
        var data_enteries1: [ChartDataEntry] = []
        
        for i in 0..<data1.count
        {
            data_enteries1.append(ChartDataEntry(x: dataPoints[i] as? Double ?? 0.0, y: data1[i] as? Double ?? 0.0))
           
//            if (i == 1 || i == data1.count - 1)
//            {
//                LeftAxisFormatter.stringForValue(data1[i] as! Double, axis: yaxis)
//            }
//            else
//            {
//                LeftAxisFormatter.stringForValue(4.0, axis: yaxis)
//            }
        }
        
        let lineChartDataSetTemp1 = LineChartDataSet(values: data_enteries1, label: chart_legend)
        lineChartDataSetTemp1.setColor(UIColor.init(netHex_String: chart_color))
        lineChartDataSetTemp1.lineWidth = 2.6
        xaxis.valueFormatter = xAxisFormatter
        yaxis.valueFormatter = LeftAxisFormatter
        self.linechart_view.xAxis.valueFormatter = xaxis.valueFormatter
        self.linechart_view.leftAxis.valueFormatter = yaxis.valueFormatter
        lineChartDataSetTemp1.drawCirclesEnabled = false
        lineChartDataSetTemp1.mode = .stepped
        lineChartDataSetTemp1.drawValuesEnabled = false

        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSetTemp1)
        
        let lineChartD = LineChartData(dataSets: dataSets)
        lineChartD.setDrawValues(false)
        self.linechart_view.data = lineChartD
        self.linechart_view.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        self.linechart_view.xAxis.labelPosition = .bottom
        self.linechart_view.xAxis.granularityEnabled = true
        self.linechart_view.xAxis.granularity  = 1.0
        self.linechart_view.xAxis.avoidFirstLastClippingEnabled = true
        self.linechart_view.doubleTapToZoomEnabled=false
        self.linechart_view.rightAxis.enabled=false
        self.linechart_view.scaleYEnabled = false
        self.linechart_view.scaleXEnabled = true

        self.linechart_view.chartDescription?.enabled = false
        self.linechart_view.xAxis.drawGridLinesEnabled = true
        self.linechart_view.leftAxis.drawGridLinesEnabled = true
        self.linechart_view.leftAxis.axisMinimum = -0.2
        self.linechart_view.leftAxis.axisMaximum = 1.2
        self.linechart_view.highlightPerTapEnabled = false
        self.linechart_view.highlightPerDragEnabled = false
        self.linechart_view.leftAxis.drawLabelsEnabled = true
        self.linechart_view.drawBordersEnabled = true
        self.linechart_view.extraLeftOffset = 14
        self.linechart_view.borderColor = .lightGray
        self.linechart_view.legend.font = NSUIFont.boldSystemFont(ofSize: 14)
        self.linechart_view.legend.yOffset = 10
        self.linechart_view.xAxis.centerAxisLabelsEnabled = true
        self.linechart_view.xAxis.labelCount = 5
        if Global.IS.IPAD_PRO || Global.IS.IPAD {
        
            self.linechart_view.legend.font = NSUIFont.boldSystemFont(ofSize: 22)
            self.linechart_view.legend.yOffset = 20
            self.linechart_view.legend.formSize = 20
        }
        
        //Change Time stamp while it zooming
        if linechart_view.scaleX > 1.0 {
            strEffiTimestampYaxis = "dd-MMM HH:mm"  // Zooming Enabled
            linechart_view.xAxis.labelCount = 4
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
                linechart_view.xAxis.labelCount = 4
            }
        } else  {
            strEffiTimestampYaxis = "dd-MMM"  // No zooming and Scaling
            linechart_view.xAxis.labelCount = 7
            if !(Global.IS.IPAD_PRO || Global.IS.IPAD) {
                linechart_view.xAxis.labelCount = 7
            }
        }
        
        countEffiAnimation == 0 ? linechart_view.animate(xAxisDuration: 2, yAxisDuration: 2) : linechart_view.animate(xAxisDuration: 0, yAxisDuration: 0)
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
    
    @IBAction func build_click(sender: UIButton) {
        self.linechart_view.zoom(scaleX: 0.0, scaleY: 0.0, x: 0.0, y: 0.0)
        self.linechart_data(forhours:build_hours)
    }
   
    @IBAction func dropdown_button(_ sender: AnyObject?) {
        self.dropdown_tableview.isHidden=false
    }
    
    @objc func Logo_Clicked() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.navigationController?.popToRootViewController(animated: true)
    }
   
    @objc func dismiss_dropdown() {
        if self.dropdown_tableview != nil
        {
            self.dropdown_tableview.isHidden=true
        }
    }
    @objc func show_dropdown() {
        if self.dropdown_tableview != nil
        {
            self.dropdown_tableview.isHidden=false
        }
    }
    func dropdown()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss_dropdown))
        tap.delegate=self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.dropdown_tableview = UITableView()
        self.dropdown_tableview.backgroundColor = UIColor.white
        self.dropdown_tableview.tableFooterView = UIView()
        self.dropdown_tableview.isHidden=true
        self.dropdown_tableview.register(UITableViewCell.self, forCellReuseIdentifier: "dropdown_cell")
        self.dropdown_tableview.delegate = self
        self.dropdown_tableview.dataSource = self
        self.dropdown_tableview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(self.dropdown_tableview)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.show_dropdown))
        tap2.delegate=self
        tap2.cancelsTouchesInView = false
        self.dropdown_tableview.addGestureRecognizer(tap2)
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .top, relatedBy: .equal, toItem: self.date_rangebtn, attribute: .bottom, multiplier: 1, constant: -2)
        
        let width_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.date_rangebtn.frame.size.width)
        
        let height_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3*self.date_rangebtn.frame.size.height)
        
        let centerhorizontally_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .centerX, relatedBy: .equal, toItem: self.date_rangebtn, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width_constraint,height_constraint,top_constraint,centerhorizontally_constraint])
        self.anycolorborder(forview: self.dropdown_tableview, radius: 2,color: UIColor.lightGray)
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / M_PI * radians
    }
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        let pitch = degrees(radians: attitude.pitch)
        let yaw = degrees(radians: attitude.yaw)
        self.pitchCalculation = pitch
        self.yawCalculation = (yaw * (-1 ))
        self.rollCalculation = roll
     //   print("attitude--->>\(attitude),roll--->>>>\(roll),pitch---->\(pitch),yaw---->\(yaw)")
    }

    func motionCalculation()
    {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
                    } else {
                        //handle the error
                    }
            })
        }
    }

    func topassLineorientationTopiechart() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            print("HomeBtnright")
        }
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            
               print("HomeBtnleft")
            if tosetLandcaperightorleft == "HomeBtnright" {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")

            }
            
        }
        
        if   (UIDevice.current.orientation == UIDeviceOrientation.portrait){
            print("portrait")
            
        }
        if UIDevice.current.orientation.isFlat {
            print("Flat")
            
        }
        if motionManager.isDeviceMotionAvailable
        {
            if  (pitchCalculation > 9)  && (rollCalculation < 10) && (rollCalculation > -10) || (UIDevice.current.orientation.isPortrait )
            {
                // Its portrait mode
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
            if (tosetLandcaperightorleft == "HomeBtnright" ) && UIDevice.current.orientation.isFlat  {
                   
                   UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                   UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }

            
        }
    }
    
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdown_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dropdown_cell", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = self.date_rangebtn.titleLabel?.font
        cell.textLabel?.text = dropdown_array[indexPath.row]
        cell.textLabel?.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dropdown_tableview.isHidden = true
        date_rangebtn.setTitle("  "+dropdown_array[indexPath.row], for: .normal)
        build_hours=Int(indexPath.row)+1
        defalts.setValue(build_hours, forKey: "hours_selected")
    }
    
    // MARK: - Linechart protocol
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.date_rangebtn.frame.size.height
    }
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
        self.setChart(dataPoints: self.xchart_array, data1: self.ychart_array)
    }
    
}
