//
//  CircularProgressView.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/7/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    var color: UIColor = UIColor.clear {
        didSet {
            progressLayer.strokeColor = color.cgColor
        }
    }
    
    var progress: Float = 0.0 {
        didSet {
            if oldValue == progress {
                return
            }
            
            progressLayer.path = UIBezierPath(
                arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                radius: frame.height / 2,
                startAngle: degreesToRadians(0),
                endAngle: degreesToRadians(progress * 360),
                clockwise: true
            ).cgPath
            
            resetAnimation()
    
            progressLabel.text = "\(Int(progress*100))%"
        }
    }
    
    var duration: CFTimeInterval = CircularProgressView.DEFAULT_ANIMATION_DURATION {
        didSet {
            if oldValue == duration {
                return
            }
            
            animation.duration = duration
            resetAnimation()
        }
    }
    
    fileprivate var didAnimate = false
    
    fileprivate static let DEFAULT_ANIMATION_DURATION = 2.0
    fileprivate static let ANIMATION_KEY = "circularProgressAnimation"
    
    fileprivate let progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 8
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = kCALineCapRound
        
        return progressLayer
    }()
    
    fileprivate let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
    
        animation.toValue = 1
        animation.duration = CircularProgressView.DEFAULT_ANIMATION_DURATION
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        return animation
    }()
    
    fileprivate let progressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        
        layer.cornerRadius = frame.width / 2
        layer.addSublayer(progressLayer)
        
        progressLabel.frame = CGRect(origin: CGPoint(x: bounds.midX - frame.width / 2, y: 0), size: frame.size)
        addSubview(progressLabel)
    }
    
    fileprivate func resetAnimation() {
        progressLayer.removeAnimation(forKey: CircularProgressView.ANIMATION_KEY)
        progressLayer.add(animation, forKey: CircularProgressView.ANIMATION_KEY)
    }

    // NOTE: Because UIBezierPaths start drawing at the 90° mark, we have to subtract 90° to make the drawing start at the top of the circle.
    fileprivate func degreesToRadians(_ degrees: Float) -> CGFloat {
        return CGFloat(degrees - 90) * CGFloat.pi / 180
    }
    
}
