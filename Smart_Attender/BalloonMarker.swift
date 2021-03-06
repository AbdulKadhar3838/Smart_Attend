

import Foundation
import Charts


open class BalloonMarker: MarkerImage
{
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()
    open var setBarchart = Bool()
    
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedStringKey : Any]()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,setBarChart:Bool)
    {
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        self.setBarchart = setBarChart
        
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if let color = color
        {
            context.setFillColor(color.cgColor)
            
            
            
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    // MARK: Ballon Marker Data Passing
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if setBarchart == true { // Bar Chart
            print(highlight)
        if highlight.dataSetIndex == 1 { // Required hrs
            let label = "Required Hours" + "\n\(arrayglobalTimestampETA[0]) hrs"
            setLabel(label)
            
        } else { // ETC
            setLabel("\(arrayglobalETCTask[highlight.stackIndex])\n \(arrayglobalTimestampActual[highlight.stackIndex])")
            
            if ((isStartDateSame == false ) && (highlight.stackIndex == 0)){
                self.color = UIColor.clear
            } else {
                self.color = UIColor.lightGray
            }
        }
        } else { // Efficiency Chart
            print(highlight)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM HH:mm:ss" // for  X Axis
            let xValue = dateFormatter.string(from: Date(timeIntervalSince1970: entry.x))
            
            setLabel("\(xValue)  \n Efficiency: \(String(entry.y)) %")
            print()
            
            
        }
    }
    
    open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        
        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedStringKey.font] = self.font
        _drawAttributes[NSAttributedStringKey.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedStringKey.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
        
    }
}
