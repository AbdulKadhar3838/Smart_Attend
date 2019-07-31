
import UIKit
import Charts
import CoreMotion


class PieChart_ViewController: UIViewController,ChartViewDelegate,UITableViewDelegate,UITableViewDataSource {
    // MARK: - Connected Outlets
    var dropdown_tableview: UITableView!
    @IBOutlet weak var piechartlegend_Tableview: UITableView!
    @IBOutlet weak var piechat_view: PieChartView!
    @IBOutlet weak var logo_imageview: UIImageView!
    @IBOutlet weak var hours_Button: UIButton!
    @IBOutlet weak var linechart_Button1: UIButton!
    @IBOutlet weak var linechart_Button2: UIButton!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropdownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var legendTblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pieChartTrailConstraint: NSLayoutConstraint!
    @IBOutlet weak var legendTblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineBtn2TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnScarpView: UIButton!
    
    // Version 1.3
    @IBOutlet weak var constraintBottomLegendMenu: NSLayoutConstraint!
    @IBOutlet weak var viewPiechartData: UIView!
    @IBOutlet weak var btnLegendMenu: UIButton!
    @IBOutlet weak var btnBarChart: UIButton!
    @IBOutlet weak var btnEfficiencyChart: UIButton!
    @IBOutlet weak var constraintTrailEfficiencyBtn: NSLayoutConstraint!
    @IBOutlet weak var constraintLeadingHourlyChart: NSLayoutConstraint!
    
    @IBOutlet weak var lblAvgCycle: UILabel!
    @IBOutlet weak var lblHourlyQty: UILabel!
    @IBOutlet weak var lblRemainingQty: UILabel!
    @IBOutlet weak var lblCompletedQty: UILabel!
    @IBOutlet weak var lblIncident: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCycletime: UILabel!
    @IBOutlet weak var lblRequiredQty: UILabel!
    @IBOutlet weak var lblTxtAvgCycle: UILabel!
    @IBOutlet weak var lblTxtHourlyQty: UILabel!
    @IBOutlet weak var lblTxtRemainingQty: UILabel!
    @IBOutlet weak var lblTxtRequiredQty: UILabel!
    
    @IBOutlet weak var constraintTrailingLegendMenu: NSLayoutConstraint!
    @IBOutlet weak var lblCenterSeparator: UILabel!
    
    @IBOutlet weak var lblScarpQty: UILabel!
    @IBOutlet weak var lblScarpQtytitle: UILabel!
    @IBOutlet weak var constraintTopScrap: NSLayoutConstraint!
    // MARK: - Variables
    var SelectedIndex:Int!
    var chartdata_Array:NSMutableArray = []
    var chartlegend_array:NSMutableArray=[]
    var server_data:NSMutableArray=[]
    var server_colordata:[UIColor]=[]
    var device_id:String=""
    var piecurrentOrientation = ""
    var piepassingcurrentOrientation = ""
    var piecurrentflatOrientation = ""
    var rollCalculation:Double!
    var pitchCalculation:Double!
    var yawCalculation:Double!
    var tochecklandscaperightOrleft = ""
    var centeringLegendtblconstant:CGFloat = 0
    var bottomLegendtblconstant:CGFloat = 0
    var passStatus = ""
    var passCycletime = ""
    var passCompletedQty = ""
    var partNO = ""
    var passColor:UIColor?
    
    @IBOutlet var partnoLbl: UILabel!
    

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print(partNO2)
        self.partnoLbl.text = partNO2 
        
        toSetNavigationImagenTitle(titleString:"\(defalts.value(forKey: "Device_Name") as! String) - Analysis", isHamMenu: false)
        self.piechat_view.centerText = ""
        self.piechat_view.noDataText = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
        self.piechat_view.delegate = self
        piechat_view.animate(yAxisDuration: 1.4, easingOption: ChartEasingOption.easeInCubic)
        let taplogo: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.logo_taped))
        taplogo.delegate=self
        logo_imageview.addGestureRecognizer(taplogo)
        
        self.piechartlegend_Tableview.delegate=self
        self.piechartlegend_Tableview.dataSource=self
        self.piechartlegend_Tableview.estimatedRowHeight = Global.ScreenSize.SCREEN_MAX_LENGTH * 0.036
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        self.linechart_Button1.isHidden=true
        self.linechart_Button2.isHidden=true
        self.btnEfficiencyChart.isHidden=true
        self.btnBarChart.isHidden=true
        self.btnScarpView.isHidden = true
        appdelegate.shouldRotate = true
        self.piechartlegend_Tableview.isHidden=true
        self.piechat_view.isHidden=true
        self.btnLegendMenu.isHidden = true
        self.viewPiechartData.isHidden = true
       // self.logoHeightConstraint.constant = portraitHeight * 0.08967
        self.dropdownHeightConstraint.constant = portraitHeight * 0.04891
        self.buttonHeightConstraint.constant = portraitHeight * 0.0625
        hours_Button.setTitle("    "+dropdown_array[self.getSelectedHours()-1], for: .normal)
        
        self.setPreviousorientation()
        
        self.lblCycletime.text = passCycletime
        self.lblCompletedQty.text = passCompletedQty
        self.lblStatus.text = passStatus
        self.lblStatus.adjustsFontSizeToFitWidth = true
        self.settingUIColor()
       
        
    }
    
    override func viewDidLayoutSubviews() {
//        btnScarpView.layer.cornerRadius = btnScarpView.frame.height * 0.5
       self.piechat_view.bringSubview(toFront:btnScarpView )
    }
    
   override func viewWillAppear(_ animated: Bool) {
        self.chart_data(forhours: self.getSelectedHours())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true

        self.blueborder_dynamicradius(forview:self.hours_Button, radius:5)
        if self.dropdown_tableview == nil {
            self.dropdown()
        }
        if (hours_Button.titleLabel?.text != "    \(dropdown_array[self.getSelectedHours()-1])")
        {
            hours_Button.setTitle("    "+dropdown_array[self.getSelectedHours()-1], for: .normal)
            self.chart_data(forhours: self.getSelectedHours())
        }
        motionCalculation()
        
        
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.transitionChanges()
        }, completion: nil)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.transitionChanges()
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
    
    func degrees(radians:Double) -> Double {
        return 180 / M_PI * radians
    }
    
    func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
        let attitude = deviceMotion.attitude
        let roll = degrees(radians: attitude.roll)
        let pitch = degrees(radians: attitude.pitch)
        let yaw = degrees(radians: attitude.yaw)
        self.rollCalculation = roll
        self.pitchCalculation = pitch
        self.yawCalculation = (yaw * (1 ))
      //  print("attitude--->>\(attitude),roll--->>>>\(roll),pitch---->\(pitch),yaw---->\(yaw)")
    }

    func transitionChanges()
    {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            landscapeConstraint()
        } else {
            print("Portrait")
            portraitConstraint()
            
        }
    }
    
    func setPreviousorientation() {
        if (self.piecurrentOrientation == "Portrait") {
            portraitConstraint()
        } else if(self.piecurrentOrientation == "Landscape"){
            landscapeConstraint()
        } else if(self.piecurrentOrientation == "FlatPortrait") {
            portraitConstraint()
        } else if(self.piecurrentOrientation == "FlatLandscape") {
            landscapeConstraint()
        }
    }
    
    func portraitConstraint()
    {
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.piechartlegend_Tableview, attribute: .top, relatedBy: .equal, toItem: self.piechat_view, attribute: .bottom, multiplier: 1, constant: 12)
        self.legendTblTopConstraint.isActive = false
        top_constraint.isActive = true
        self.legendTblTopConstraint = top_constraint
        
        let top_constraint2:NSLayoutConstraint=NSLayoutConstraint(item: self.linechart_Button2, attribute: .top, relatedBy: .equal, toItem: self.linechart_Button1, attribute: .bottom, multiplier: 1, constant: 8)
        self.lineBtn2TopConstraint.isActive = false
        top_constraint2.isActive = true
        self.lineBtn2TopConstraint = top_constraint2
        
        let trail_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.piechat_view, attribute: .trailing, multiplier: 1, constant: 26)
        self.pieChartTrailConstraint.isActive = false
        trail_constraint.isActive = true
        self.pieChartTrailConstraint = trail_constraint
        
//        self.legendTblHeightConstraint.constant = -60
//        if (Global.IS.IPAD || Global.IS.IPAD_PRO)
//        {
//            self.legendTblHeightConstraint.constant = -90
//        }
        
        /// Version 1.3 Ra
        let bottomLegendMenu:NSLayoutConstraint=NSLayoutConstraint(item: self.btnLegendMenu, attribute: .bottom, relatedBy: .equal, toItem: self.piechat_view, attribute: .bottom, multiplier: 1, constant: 5)
        self.constraintBottomLegendMenu.isActive = false
        bottomLegendMenu.isActive = true
        self.constraintBottomLegendMenu = bottomLegendMenu // Bottom For Legend menu
        
        let leadingHourly:NSLayoutConstraint=NSLayoutConstraint(item: self.linechart_Button2, attribute: .leading, relatedBy: .equal, toItem: self.piechat_view, attribute: .leading, multiplier: 1, constant: 0)
        self.constraintLeadingHourlyChart.isActive = false
        leadingHourly.isActive = true
        self.constraintLeadingHourlyChart = leadingHourly  // Leading For Hourly or Line chart Button2
        
        let trailEfficiecny:NSLayoutConstraint=NSLayoutConstraint(item: self.btnEfficiencyChart, attribute: .trailing, relatedBy: .equal, toItem: self.piechat_view, attribute: .trailing, multiplier: 1, constant: 0)
        self.constraintTrailEfficiencyBtn.isActive = false
        trailEfficiecny.isActive = true
        self.constraintTrailEfficiencyBtn = trailEfficiecny // Trailing For Efficiency Btn
        
        let trailLegendMenu:NSLayoutConstraint=NSLayoutConstraint(item: self.btnLegendMenu, attribute: .trailing, relatedBy: .equal, toItem: self.piechat_view, attribute: .trailing, multiplier: 1, constant: 0)
        self.constraintTrailingLegendMenu.isActive = false
        trailLegendMenu.isActive = true
        self.constraintTrailingLegendMenu = trailLegendMenu // Trailing For btnLegendMenu
        
        constraintTopScrap.constant = 20
    }
    
    func landscapeConstraint()
    {
        if Global.IS.IPAD || Global.IS.IPAD_PRO {
            centeringLegendtblconstant = 80
            }
        else {
            centeringLegendtblconstant = 15
            }
        bottomLegendtblconstant = centeringLegendtblconstant+8
        
        print("---->>>>>\(centeringLegendtblconstant)")
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.piechartlegend_Tableview, attribute: .top, relatedBy: .equal, toItem: self.piechat_view, attribute: .top, multiplier: 1, constant: centeringLegendtblconstant)
        self.legendTblTopConstraint.isActive = false
        top_constraint.isActive = true
        self.legendTblTopConstraint = top_constraint
        
     /*   let top_constraint2:NSLayoutConstraint=NSLayoutConstraint(item: self.linechart_Button2, attribute: .top, relatedBy: .equal, toItem: self.piechat_view, attribute: .bottom, multiplier: 1, constant:bottomLegendtblconstant)
        self.lineBtn2TopConstraint.isActive = false
        top_constraint2.isActive = true
        self.lineBtn2TopConstraint = top_constraint2 */
        
        let top_constraint2:NSLayoutConstraint=NSLayoutConstraint(item: self.linechart_Button2, attribute: .top, relatedBy: .equal, toItem: self.linechart_Button1, attribute: .top, multiplier: 1, constant:0)
        self.lineBtn2TopConstraint.isActive = false
        top_constraint2.isActive = true
        self.lineBtn2TopConstraint = top_constraint2 //Ra Temp 
        
        let trail_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.piechartlegend_Tableview, attribute: .leading, relatedBy: .equal, toItem: self.piechat_view, attribute: .trailing, multiplier: 1, constant: 12)
        self.pieChartTrailConstraint.isActive = false
        trail_constraint.isActive = true
        self.pieChartTrailConstraint = trail_constraint
        
        self.legendTblHeightConstraint.constant = 0
        
        /// Version 1.3 Ra
     
        let bottomLegendMenu:NSLayoutConstraint=NSLayoutConstraint(item: self.btnLegendMenu, attribute: .bottom, relatedBy: .equal, toItem: self.viewPiechartData, attribute: .top, multiplier: 1, constant: 0)
        self.constraintBottomLegendMenu.isActive = false
        bottomLegendMenu.isActive = true
        self.constraintBottomLegendMenu = bottomLegendMenu // Bottom For Legend menu
        
        let leadingHourly:NSLayoutConstraint=NSLayoutConstraint(item: self.linechart_Button2, attribute: .leading, relatedBy: .equal, toItem: self.linechart_Button1, attribute: .trailing, multiplier: 1, constant: 9)
        self.constraintLeadingHourlyChart.isActive = false
        leadingHourly.isActive = true
        self.constraintLeadingHourlyChart = leadingHourly // Leading For Hourly or Line chart Button2
        
        
        let trailEfficiecny:NSLayoutConstraint=NSLayoutConstraint(item: self.btnEfficiencyChart, attribute: .trailing, relatedBy: .equal, toItem: self.btnBarChart, attribute: .leading, multiplier: 1, constant: -9)
        self.constraintTrailEfficiencyBtn.isActive = false
        trailEfficiecny.isActive = true
        self.constraintTrailEfficiencyBtn = trailEfficiecny // Trailing For Efficiency Btn
        
        let trailLegendMenu:NSLayoutConstraint=NSLayoutConstraint(item: self.btnLegendMenu, attribute: .trailing, relatedBy: .equal, toItem: self.viewPiechartData, attribute: .leading, multiplier: 1, constant: 0)
        self.constraintTrailingLegendMenu.isActive = false
        trailLegendMenu.isActive = true
        self.constraintTrailingLegendMenu = trailLegendMenu // Trailing For btnLegendMenu
        
        constraintTopScrap.constant = 5
    }
    
    func chart_data(forhours: Int)
    {
        defalts.setValue(forhours, forKey: "hours_selected")
        self.linechart_Button1.isHidden=true
        self.linechart_Button2.isHidden=true
        self.btnBarChart.isHidden=true
        self.btnEfficiencyChart.isHidden=true
        self.startloader(msg: "Loading.... ")
        Global.server.Get(path: "EfficiencyMonitor/Chart/\(device_id)/\(forhours)", jsonObj: nil, completionHandler: { (success,failure,noConnection) in
            self.stoploader()
            if(failure == nil && noConnection == nil)
            {
                let dict:NSDictionary=success as! NSDictionary
                if(dict["IsSuccess"] != nil)
                {
                    let success=dict.value(forKey: "IsSuccess") as! Bool
                    if (success)
                    {
                        self.server_data.removeAllObjects()
                        self.chartdata_Array.removeAllObjects()
                        self.server_colordata=[]
                        let data:NSArray = dict.value(forKey: "pieChart") as! NSArray
                        self.server_data = data.mutableCopy() as! NSMutableArray
                        let data2:NSArray=dict.value(forKey: "pieLegent") as! NSArray
                        self.chartlegend_array=data2.mutableCopy() as! NSMutableArray
                        self.Load_data()
                        
                        //Dashboard Detailed View
                        if let hourlyResponse = dict.value(forKey: "HourlyResponse") as? NSDictionary
                        {
                            if let avgCycle = hourlyResponse.value(forKey: "HourSingleCycle") as? String {
                                self.lblAvgCycle.text = avgCycle
                            }
                            if let hourlyQty = hourlyResponse.value(forKey: "HourCompletedQty") as? Int {
                                self.lblHourlyQty.text = "\(hourlyQty)"
                            }
                            if let remainingQty = hourlyResponse.value(forKey: "RemainingQuantity") as? Int {
                                self.lblRemainingQty.text = "\(remainingQty)"
                            }
                            if let requiredQty = hourlyResponse.value(forKey: "RequiredQuantity") as? Int {
                                self.lblRequiredQty.text = "\(requiredQty)"
                            }
                            if let hourlyScrap = hourlyResponse.value(forKey: "HourlyScrap") as? Int {
                                self.lblScarpQty.text = "\(hourlyScrap)"
                            }
                        }
                         if let dashboardDevice = dict.value(forKey: "DashboardDevice") as? NSDictionary {
                            if let incident = dashboardDevice.value(forKey: "Count") as? Int {
                                self.lblIncident.text = "\(incident) INCIDENT"
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
    func Load_data()
    {
        let count:Int=self.server_data.count
        for j in 0..<count
        {
            let temp:NSDictionary=self.server_data[j] as! NSDictionary
            let data=(temp.value(forKey: "value") as! NSString).doubleValue
            self.chartdata_Array.add(data)
            let color_strng:NSString=temp.value(forKey: "color") as! NSString
            let color:UIColor=UIColor.init(netHex_String: color_strng as String)
            self.server_colordata.append(color)
            
            
        }
        
        if (count>0)
        {
            self.piechat_view.isHidden=false
            self.btnLegendMenu.isHidden = false
            self.viewPiechartData.isHidden = false
            for i in 0..<count
            {
                self.piechat_view.centerText="There is no history!"
                let temp_dict:NSDictionary=self.server_data[i] as! NSDictionary
                let chartdata=(temp_dict.value(forKey: "value") as! NSString).doubleValue
                if chartdata>0 {
                    self.piechat_view.centerText=""
                    break
                }
            }
            self.setDataCount(count: self.chartdata_Array.count, data: self.chartdata_Array)
            print(self.chartdata_Array)
            
            let temp_dict:NSDictionary=self.server_data[0] as! NSDictionary
            let chartdata=(temp_dict.value(forKey: "value") as! NSString).doubleValue
            var title:String=temp_dict.value(forKey: "label") as! String
             currentShotdownId = temp_dict.value(forKey: "CurrentShutdownMasterID") as? Int ?? 0
            print("CurrentShutdownMasterID :  \(currentShotdownId) ")
            if title.contains(" ") {
               title = title.replacingOccurrences(of: " ", with: " \n")
            }
            piechat_view.centerText = title + "\n" +  String(format: "%.2f", chartdata) + "%"
            SelectedIndex=0
            self.chart_select(highlighted: SelectedIndex)
            let hg:Highlight=Highlight.init(x: Double(SelectedIndex), y: chartdata, dataSetIndex: 0)
            self.piechat_view.highlightValue(hg)
            self.piechartlegend_Tableview.reloadData()
        }
        else
        {
            self.piechartlegend_Tableview.isHidden=true
            self.piechat_view.isHidden=true
            self.btnLegendMenu.isHidden = true
            self.viewPiechartData.isHidden = true
            self.showNodata(msgs: "No Records Found. Try Again.")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        motionManager.stopDeviceMotionUpdates()
        
    }
    
    // MARK: - Button Actions
    @IBAction func linechart(_ sender: UIButton) {
       

        motionManager.stopDeviceMotionUpdates()
        topasscurrentorientationTochart()
        let temp:NSDictionary=self.server_data[SelectedIndex] as! NSDictionary
        if sender.tag == 2 {
            let linechart = self.storyboard?.instantiateViewController(withIdentifier: "LineChart_ViewController") as! LineChart_ViewController
            
          //  linechart.piepassingOrientation = piepassingcurrentOrientation
            linechart.tosetLandcaperightorleft = tochecklandscaperightOrleft
            linechart.device_id=device_id
            linechart.chart_legend=temp.value(forKey: "label") as! String
            linechart.chart_color=temp.value(forKey: "color") as! String
            linechart.chart_index=temp.value(forKey: "input") as! String
            self.navigationController?.pushViewController(linechart, animated: true)
        }
        else if sender.tag == 1 // High Low Chart
        {
          let linechart = self.storyboard?.instantiateViewController(withIdentifier: "HighLowGraphView") as! HighLowGraphView
            
           // linechart.piepassingforHighLowOrientation = piepassingcurrentOrientation
            linechart.tosetLandcaperightorleft = tochecklandscaperightOrleft
            linechart.device_id=device_id
            linechart.chart_legend=temp.value(forKey: "label") as! String
            linechart.chart_color=temp.value(forKey: "color") as! String
            linechart.chart_index=temp.value(forKey: "input") as! String
            self.navigationController?.pushViewController(linechart, animated: true)
            
        } else if sender.tag == 3  { // Efficiency Chart
            let efficencyLineChart = self.storyboard?.instantiateViewController(withIdentifier: "EfficiencyChartViewController") as! EfficiencyChartViewController
             efficencyLineChart.tosetLandcaperightorleft = tochecklandscaperightOrleft
            efficencyLineChart.deviceId=device_id
            self.navigationController?.pushViewController(efficencyLineChart, animated: true)
            
        } else{  // Stacked Horizontal Bar Chart
            
            let barchart = self.storyboard?.instantiateViewController(withIdentifier: "BarChartViewController") as! BarChartViewController
             barchart.tosetLandcaperightorleft = tochecklandscaperightOrleft
            barchart.deviceId=device_id
            self.navigationController?.pushViewController(barchart, animated: true)
          
        }
    }
   
    @IBAction func hours_Action(_ sender: Any) {
        dropdown_tableview.isHidden=false
    }
    
    /// Legend Hamburger Menu
    
    @IBAction func toShowLegendTable(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.piechartlegend_Tableview.isHidden = false
                self.piechartlegend_Tableview.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                UIView.animate(withDuration: 0.15,
                               animations: {
                                self.piechartlegend_Tableview.transform = CGAffineTransform(scaleX: 1, y: 0.005)
                                
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.4) {
                                    self.piechartlegend_Tableview.transform = CGAffineTransform.identity
                                }
                })
        } else {
            
            self.piechartlegend_Tableview.isHidden = true
       }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func scarpAction(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScarpVC1") as! ScarpVC1
        vc.deviceId=device_id
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func topasscurrentorientationTochart() {
        
        let width1 = UIScreen.main.bounds.size.width
        let height1 = UIScreen.main.bounds.size.height
        print(" Global.ScreenSize.SCREEN_WIDTH->\(width1),Global.ScreenSize.SCREEN_HEIGHT-->\(height1)")
        if (width1) > (height1) {
            self.piecurrentflatOrientation = "Landscape"//checking Landscape mode
        } else if (width1) < (height1){
            self.piecurrentflatOrientation = "Portrait"//checking Portait mode
        }
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            tochecklandscaperightOrleft = "HomeBtnright"
        }
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            tochecklandscaperightOrleft = "HomeBtnleft"
        }
        
        if   (UIDevice.current.orientation == UIDeviceOrientation.portrait){
            tochecklandscaperightOrleft = "HomeBtnleft"
            
        }
        if UIDevice.current.orientation.isFlat {
            if (piecurrentflatOrientation == "Landscape") {
                if (yawCalculation > -10  && yawCalculation < 175 ) || (yawCalculation < -170 && yawCalculation > -180 ){
                    tochecklandscaperightOrleft = "HomeBtnright"
                } else if yawCalculation < -100 || (yawCalculation > 175 && yawCalculation < 180 ){
                    tochecklandscaperightOrleft = "HomeBtnleft"
                }
            }
            
            if (piecurrentflatOrientation == "Portrait") {
                tochecklandscaperightOrleft = "HomeBtnleft"
            }
        }

    }
   func settingUIColor() {
    let arrayLabel:[UILabel] = [lblAvgCycle,lblTxtAvgCycle,lblHourlyQty,lblTxtHourlyQty,lblRemainingQty,lblTxtRemainingQty,lblRequiredQty,lblTxtRequiredQty,lblCompletedQty,lblCycletime,lblIncident]
    arrayLabel.map({$0.textColor = self.passColor?.darker(by: 10.0)})
    self.lblStatus.textColor = self.passColor?.lighter(by: 10.0)
    self.lblCenterSeparator.backgroundColor = self.passColor
    lblStatus.adjustsFontSizeToFitWidth = true
    lblScarpQtytitle.textColor = self.passColor?.darker(by: 10.0)
    lblScarpQty.textColor = self.passColor?.darker(by: 10.0)
    
    }
    
    func setDataCount(count: Int, data: NSMutableArray) {
        var yVals1: [ChartDataEntry] = [ChartDataEntry]()
        // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
        
        let counter = 0.0
        for i in 0..<data.count
        {
            let dataEntry = ChartDataEntry(x: counter, y:data[i] as! Double )
            yVals1.append(dataEntry)
        }
        
        let dataSet: PieChartDataSet = PieChartDataSet(values: yVals1, label: "Run Time")
        dataSet.sliceSpace = 1.6
        // add a lot of colors
        dataSet.colors = self.server_colordata
        dataSet.selectionShift = 7.0
                let data: PieChartData = PieChartData(dataSet: dataSet)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.clear)
        self.piechat_view.data = data
        self.piechat_view.rotationAngle = 270.0
        self.piechat_view.highlightValues(nil)
        self.piechat_view.chartDescription?.text="" //Chart Data
        self.piechat_view.legend.enabled=false
        self.piechat_view.noDataText="No data or Empty data provided"
        self.piechat_view.holeRadiusPercent = 0.8
        self.piechat_view.drawSlicesUnderHoleEnabled = true
        self.piechat_view.transparentCircleRadiusPercent = 0.85
        
        
        
        
        if Global.IS.IPHONE_5 {
            dataSet.selectionShift = 5.0
            
        } else if Global.IS.IPAD || Global.IS.IPAD_PRO {
            dataSet.selectionShift = 28.0
        }

       
       
    }
    
    // MARK: - Dropdown Methods
    @objc func show_dropdown() {
        if dropdown_tableview != nil
        {
            dropdown_tableview.isHidden=false
        }
    }
    func dropdown()
    {
        self.dropdown_tableview = UITableView()
        self.dropdown_tableview.backgroundColor = UIColor.white
        self.dropdown_tableview.tableFooterView = UIView()
        self.dropdown_tableview.isHidden=true
        self.dropdown_tableview.register(UITableViewCell.self, forCellReuseIdentifier: "dropdown_cell")
        self.dropdown_tableview.delegate = self
        self.dropdown_tableview.dataSource = self
        self.dropdown_tableview.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(self.dropdown_tableview)
        self.blueborder_dynamicradius(forview:self.dropdown_tableview, radius:2)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss_dropdown))
        tap.delegate=self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.show_dropdown))
        tap2.delegate=self
        tap2.cancelsTouchesInView = false
        dropdown_tableview.addGestureRecognizer(tap2)
        
        let top_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .top, relatedBy: .equal, toItem: self.hours_Button, attribute: .bottom, multiplier: 1, constant: -2)
        
        let width_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .width, relatedBy: .equal, toItem: self.hours_Button, attribute: .width, multiplier: 1, constant: 0)
        
        let height_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 3*self.hours_Button.frame.size.height)
        
        let centerhorizontally_constraint:NSLayoutConstraint=NSLayoutConstraint(item: self.dropdown_tableview, attribute: .centerX, relatedBy: .equal, toItem: self.hours_Button, attribute: .centerX, multiplier: 1, constant: 0)
     NSLayoutConstraint.activate([width_constraint,height_constraint,top_constraint,centerhorizontally_constraint])
    }
    
    // MARK: - UITableViewDelegate protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int!
        if tableView == self.piechartlegend_Tableview{
            count = chartlegend_array.count
            
            
        }
        else{
            count = dropdown_array.count
        }
        return count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if tableView == self.piechartlegend_Tableview
        {
        if SelectedIndex != nil {
        if SelectedIndex == indexPath.row {
            cell.setSelected(true, animated: true)
            let temp:NSDictionary=self.server_data[SelectedIndex] as! NSDictionary
            cell.contentView.backgroundColor=UIColor.init(netHex_String: temp.value(forKey: "color") as! String)
            self.piechartlegend_Tableview.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.piechartlegend_Tableview
        {
            let cell: PieLegend_TableViewCell = tableView.dequeueReusableCell(withIdentifier: "pielegend", for: indexPath) as! PieLegend_TableViewCell
            cell.contentView.backgroundColor=UIColor.clear
            print(self.server_data)
            let temp:NSDictionary=self.server_data[indexPath.row] as! NSDictionary
            cell.machine_statuslbl?.text = temp.value(forKey: "label") as? String
            cell.machine_runtimelbl?.text = chartlegend_array.object(at: indexPath.row) as? String
            cell.machine_colorlbl.backgroundColor=UIColor.init(netHex_String: temp.value(forKey: "color") as! String) 
            return cell
        }
        else
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dropdown_cell", for: indexPath) as UITableViewCell
            cell.selectionStyle = .none
            cell.textLabel?.textColor=theme_color
            cell.textLabel?.font=hours_Button.titleLabel?.font
            cell.textLabel?.text = dropdown_array[indexPath.row]
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       var height : CGFloat!
        if tableView == self.piechartlegend_Tableview
        {
        
           height = UITableViewAutomaticDimension
        }
        else
        {
            height = hours_Button.frame.size.height
        }
        return height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.piechartlegend_Tableview
        {
            let temp:NSDictionary=self.server_data[indexPath.row] as! NSDictionary
            self.chart_select(highlighted: Int(indexPath.row))
            let runtime:Double=(temp.value(forKey: "value") as! NSString).doubleValue
            let hg:Highlight=Highlight.init(x: Double(SelectedIndex), y: runtime, dataSetIndex: 0)
            self.piechat_view.highlightValue(hg)
        }
        else
        {
        hours_Button.setTitle("    "+dropdown_array[indexPath.row], for: .normal)
        self.chart_data(forhours: Int(indexPath.row)+1)
        self.SelectedIndex=nil
        self.dismiss_dropdown()
        }
    }
    @objc func logo_taped()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func dismiss_dropdown() {
        if dropdown_tableview != nil
        {
            dropdown_tableview.isHidden=true
        }
    }
    
    // MARK: - Piechart protocol
    func chart_select(highlighted:Int!)
    {
        self.linechart_Button1.isHidden=false
        self.linechart_Button2.isHidden=false
        self.btnBarChart.isHidden=false
        self.btnEfficiencyChart.isHidden=false
        btnScarpView.isHidden = false
        self.dismiss_dropdown()
        SelectedIndex=highlighted
        let temp:NSDictionary=self.server_data[highlighted] as! NSDictionary
        var title:String=temp.value(forKey: "label") as? String ?? "" //For Btn Title
        
        self.linechart_Button1.setTitle("Input Analysis", for: .normal)
        self.linechart_Button2.setTitle("Incident Analysis", for: .normal)
        self.btnEfficiencyChart.setTitle("Target Analysis", for: .normal)
        self.btnBarChart.setTitle("Timeline Analysis", for: .normal)

        let runtime:Double=(temp.value(forKey: "value") as? NSString ?? "").doubleValue
        
        let runtime_percentage:Double = runtime
        if title.contains(" ") {
            title = title.replacingOccurrences(of: " ", with: "\n")
        }
        piechat_view.centerText = title + "\n" +  String(format: "%.2f", runtime_percentage) + "%"
        self.piechartlegend_Tableview.reloadData()
        let index_Path:IndexPath! =  IndexPath.init(row: highlighted, section: 0)
        let SelectedCell=self.piechartlegend_Tableview.cellForRow(at: index_Path)
        guard let cell = SelectedCell as? PieLegend_TableViewCell else {
            print("guarded here")
            return
        }
        cell.contentView.backgroundColor=UIColor.init(netHex_String: temp.value(forKey: "color") as? String ?? "#FFFFFF")
        self.piechartlegend_Tableview.scrollToRow(at: index_Path, at: .middle, animated: true)
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        self.chart_select(highlighted: Int(highlight.x))
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase){
        self.linechart_Button1.isHidden=true
        self.linechart_Button2.isHidden=true
        self.btnEfficiencyChart.isHidden=true
        self.btnScarpView.isHidden = true
        self.btnBarChart.isHidden=true
        self.dismiss_dropdown()
        self.piechartlegend_Tableview.reloadData()
        self.SelectedIndex=nil
        piechat_view.centerText = ""
    }
}
