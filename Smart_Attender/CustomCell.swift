

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var colourBtn: UIButton!
    
    @IBOutlet weak var viewBtn: UIButton!
    
    @IBOutlet var statusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.makeItCircle()
        
        self.viewBtn.layer.cornerRadius = 5
        self.viewBtn.layer.masksToBounds = true
    }

    func makeItCircle() {
        self.colourBtn.layer.masksToBounds = true
        self.colourBtn.layer.cornerRadius  = CGFloat(roundf(Float(self.colourBtn.frame.size.width/2.0)))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
