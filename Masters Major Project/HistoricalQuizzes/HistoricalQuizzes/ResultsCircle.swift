//
//  ResultsCircle.swift
//  HistoricalQuizzes
//
//  Created by Doug Williams on 02/06/2018.
//  Copyright © 2018 Doug Williams. All rights reserved.
//

import UIKit

let CirleSections = 100
let π:CGFloat = CGFloat(Double.pi)

@IBDesignable class ResultsCircle: UIView {
    
    let percentageCircleLayer: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable var percentage:Int = 75{
        didSet{
            if percentage <= CirleSections {
                //refesh the view
                setNeedsDisplay()
            }
        }
    }

    @IBInspectable var scoreLineColour:UIColor = UIColor.white
    @IBInspectable var backgroundLineColour:UIColor = UIColor.gray
    
    override func draw(_ rect: CGRect) {
        let centre = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        //let radius:CGFloat = max(bounds.width/2, bounds.height/2)*0.65
        
        let padding:CGFloat = 20
        
        let radius:CGFloat = bounds.width/2 - padding
       
        //more a line width than an arc width
        let arcWidth:CGFloat = 10
        
        let startAngle:CGFloat = 0.0 - π / 2
        
        let radiusRect = rect.insetBy(dx: padding, dy: padding)
        
        let path = UIBezierPath(ovalIn: radiusRect)
        
        path.lineWidth = arcWidth
        backgroundLineColour.setStroke()
        path.stroke()
        
        let angleDifference:CGFloat = 2*π
        
        //calulate how much of the circle to fill equally
        
        let arcLengthPerSection:CGFloat = angleDifference / CGFloat(CirleSections)
        
        //the multiply by the number of sections
        
        let outLineendAngle:CGFloat = startAngle + (CGFloat(percentage)*arcLengthPerSection)
        
        percentageCircleLayer.strokeColor = scoreLineColour.cgColor
        percentageCircleLayer.fillColor = UIColor.clear.cgColor
        percentageCircleLayer.lineWidth = 5.0
        
        //draw the percentage arc to be animated
        percentageCircleLayer.path = UIBezierPath(arcCenter: centre,
                                       radius: radius,
                                       startAngle: startAngle,
                                       endAngle: outLineendAngle,
                                       clockwise: true).cgPath
        
        layer.addSublayer(percentageCircleLayer)
    }
    func animateCircle() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        strokeEndAnimation.duration = 2.0
        strokeEndAnimation.fillMode = kCAFillModeBoth

        percentageCircleLayer.add(strokeEndAnimation, forKey: "percentageCircle")
    }
}
