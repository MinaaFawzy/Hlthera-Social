//
//  ViewPollTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewPollTVC: UITableViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelTotalPercentage: UILabel!
    @IBOutlet weak var labelOptionName: UILabel!
    @IBOutlet weak var imageSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class HSNPollProgressView:UIProgressView{
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.cornerRadius = 5
//        self.progressViewStyle = .bar
//        self.clipsToBounds = true
//        self.layer.sublayers?[1].cornerRadius = 5
//        self.subviews[1].clipsToBounds = true
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskLayerPath.cgPath
            layer.mask = maskLayer
        
        //self.layer.masksToBounds = true
    }
}


class CircularProgressBarView: UIView {
    
    // MARK: - Properties -
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func progressAnimation(duration: TimeInterval, value : Float) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fromValue = 0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 52, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        print("width ===", frame.size.width,"height ===", frame.size.height)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 14
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.systemBackground.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 15.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.init(hexString: "#027CC5").cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
}
