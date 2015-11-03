//
//  AURSliderView.swift
//  Auroma
//
//  Created by 胡秋实 on 22/10/2015.
//  Copyright © 2015 William Hu. All rights reserved.
//

import UIKit
import Foundation

class GSSliderView: UIControl {

    var minimumValue = 0.0
    var maximumValue = 1.0
    var lowerValue = 0.0 {
        didSet {
            // 3. Update the UI
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            updateLayerFrames()
            
            CATransaction.commit()
        }
    }
    var upperValue = 1.0
    let trackLayer = GSliderTrackLayer()
    let lowerThumbLayer = CALayer()
    let smallThumbLayer = CALayer()
    var thumbTouched: Bool = false
    
    var previousLocation = CGPoint()
    
    let startLayer = CALayer()
    let endLayer = CALayer()
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var trackTintColor = UIColor.RGB(255, 174, 0)
    var trackHighlightTintColor = UIColor.RGB(129, 113, 93)
    var thumbTintColor = UIColor.whiteColor()
    var curvaceousness : CGFloat = 1.0

    let scaleSpace:CGFloat = 49.0
    lazy var scalePoints:[CALayer] = {
        var temp = [CALayer]()
        let numbers = Int(self.frame.width/self.scaleSpace) + 1
        for var index = 0; index < numbers; index++ {
            let layer = CALayer()
            self.layer.insertSublayer(layer, atIndex: 0)
            layer.frame = CGRect(x: self.scaleSpace*CGFloat(index), y: self.frame.height/2 - self.trackLayer.frame.height-3,
                width: 2, height: 8)
            layer.backgroundColor = UIColor.RGB(129, 113, 93).CGColor
            temp.append(layer)
        }
        return temp
    }()
    
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        startLayer.frame = CGRect(x: -thumbWidth*2/5, y:(thumbWidth - thumbWidth*2/5)/2 , width: thumbWidth*2/5, height: thumbWidth*2/5)
        startLayer.cornerRadius = startLayer.frame.width/2.0
        startLayer.setNeedsDisplay()
        
        endLayer.frame = CGRect(x: self.frame.width, y:(thumbWidth - thumbWidth*2/5)/2 , width: thumbWidth*2/5, height: thumbWidth*2/5)
        endLayer.cornerRadius = endLayer.frame.width/2.0
        endLayer.setNeedsDisplay()
        
        updateLayerFrames()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scalePoints.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.basicConfigure()
    }
    
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false

//        setTranslatesAutoresizingMaskIntoConstraints(false)
        self.basicConfigure()
    }
    

    func basicConfigure() {
        self.backgroundColor = UIColor.clearColor()
        trackLayer.backgroundColor = UIColor.RGB(129, 113, 93).CGColor
        trackLayer.rangeSlider = self
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.backgroundColor = UIColor.RGB(189, 126, 9).CGColor
        layer.addSublayer(lowerThumbLayer)
        
        smallThumbLayer.backgroundColor = UIColor.RGB(255, 174, 0).CGColor
        layer.addSublayer(smallThumbLayer)
        
        startLayer.backgroundColor = UIColor.RGB(255, 174, 0).CGColor
        layer.addSublayer(startLayer)
        
        endLayer.backgroundColor = UIColor.RGB(129, 113, 93).CGColor
        layer.addSublayer(endLayer)
        
        
    }
    
    func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: frame.height/2-2)
        trackLayer.setNeedsDisplay()

        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
            width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.cornerRadius = lowerThumbLayer.frame.width/2
        lowerThumbLayer.setNeedsDisplay()
        
        
        let smallThumberLayerWidth = thumbWidth - 16
        smallThumbLayer.frame = CGRect(x: lowerThumbCenter - smallThumberLayerWidth / 2.0, y: 8, width: smallThumberLayerWidth, height: smallThumberLayerWidth)
        smallThumbLayer.cornerRadius = smallThumbLayer.frame.width/2.0
        smallThumbLayer.setNeedsDisplay()
        
        
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    // MARK: touches
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)

        if lowerThumbLayer.frame.contains(previousLocation) {
            thumbTouched = true
        }
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        // 2. Update the values
        if thumbTouched {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        }
        
//        // 3. Update the UI
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        
//        updateLayerFrames()
//        
//        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    
}
