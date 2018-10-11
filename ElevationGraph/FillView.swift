//
//  FillView.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/21/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

class FillLayer: CALayer {
    struct Constant {
        static let progressKey = "progress"
        static let doneColor = UIColor.gray
        static let todoColor1 = UIColor.blue.withAlphaComponent(0.5)
        static let todoColor2 = UIColor.green.withAlphaComponent(0.5)
        static let barsCount = 5
    }

    @objc dynamic var progress : CGFloat = 0
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        // Typically, the method is called to create the Presentation layer.
        // We must copy the parameters to look the same.
        guard let otherLayer = layer as? FillLayer else {
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        return (key == Constant.progressKey) ? true : super.needsDisplay(forKey: key)
    }
    
    override func draw(in context: CGContext) {
        guard (0...1) ~= self.progress else {
            return
        }
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let barWidth = width / CGFloat(Constant.barsCount)
        
        if (self.progress > 0) {
            drawBar(in: CGRect(x: 0, y: 0, width: width * self.progress, height: height), color: Constant.doneColor, context: context)
        }
        
        let firstBar = Int((width * self.progress) / barWidth)
        
//        print("progress: \(self.progress), firstBar: \(firstBar)")
        
        if (firstBar >= Constant.barsCount) {
            return
        }
        
        let firstBarX = width * self.progress
        let firstBarWidth = barWidth - firstBarX.mod(by: barWidth)
        drawBar(in: CGRect(x: firstBarX, y: 0, width: firstBarWidth, height: height), color: colorForBar(firstBar), context: context)

        if (firstBar >= Constant.barsCount - 1) {
            return
        }

        for i in firstBar + 1 ..< Constant.barsCount {
            drawBar(in: CGRect(x: CGFloat(i) * barWidth, y: 0, width: barWidth, height: height), color: colorForBar(i), context: context)
        }
    }
    
    private func colorForBar(_ index: Int) -> UIColor {
        let color = ((index % 2) > 0) ? Constant.todoColor1 : Constant.todoColor2
//        print("index: \(index), color: \(color)")
        return color
    }
    
    private func drawBar(in rect: CGRect, color: UIColor, context: CGContext) {
        context.saveGState()
        
        context.addRect(rect)
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        context.restoreGState()
    }
}

class FillView: UIView {
    override class var layerClass : AnyClass {
        return FillLayer.self
    }
    
    private var fillLayer: FillLayer {
        guard let fillLayer = self.layer as? FillLayer else {
            fatalError()
        }
        
        return fillLayer
    }
    
    func setProgress(_ progress: CGFloat, duration: TimeInterval) {
        let normalizedProgress = max(min(1, progress), 0)
        let currentProgress = self.progress
        
        if (normalizedProgress == currentProgress) {
            self.fillLayer.setNeedsDisplay()
            return
        }
        
        self.fillLayer.removeAnimation(forKey: FillLayer.Constant.progressKey)
        
        if (duration > 0) {
            let animation = CABasicAnimation(keyPath: FillLayer.Constant.progressKey)
            animation.duration = duration
            animation.fromValue = NSNumber(value: Float(self.progress))
            animation.toValue = NSNumber(value: Float(normalizedProgress))
            self.fillLayer.add(animation, forKey: FillLayer.Constant.progressKey)
            self.fillLayer.progress = CGFloat(normalizedProgress)
        }
        else {
            self.fillLayer.progress = CGFloat(normalizedProgress)
            self.fillLayer.setNeedsDisplay()
        }
    }
    
    var progress: CGFloat {
        get {
            return CGFloat(self.fillLayer.progress)
        }
        
        set {
            self.setProgress(newValue, duration: 0.5)
        }
    }
}
