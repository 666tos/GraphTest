//
//  GraphMaskView.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/18/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

typealias Points = (data: [CGPoint], min: CGFloat, max: CGFloat)

class GraphMaskGenerator {
    let image = GraphMaskGenerator.generateImage()
    
    init() {
    }
    
    class func generatePoints(_ count: Int) -> Points {
        var points: [CGPoint] = []
        
        var min = CGFloat.infinity
        var max = -CGFloat.infinity
        
        var previousValue = CGFloat(0)
        
        for i in 0 ..< count {
            let random = CGFloat(drand48() - 0.5)
            let delta = 20 * random
            
            let value = previousValue + delta
            points.append(CGPoint(x: CGFloat(i), y: value))
            previousValue = value
            
            if (value < min) {
                min = value
            }
            else if (value > max) {
                max = value
            }
        }
        
        return (points, min, max)
    }
    
    private class func generateImage() -> UIImage? {
        let (points, minY, maxY) = generatePoints(1000)
        
        let imageWidth = CGFloat(points.count)
        let imageHeight = CGFloat(points.count)
        
        let maxDelta = max(minY.magnitude, maxY.magnitude)
        let yScale = imageHeight / (2 * maxDelta)
        let yTranslation = imageHeight/2
        
        var translatedPoints: [CGPoint] = [CGPoint(x: 0, y: yTranslation)]
        points.forEach { translatedPoints.append(CGPoint(x: $0.x, y: $0.y * yScale + yTranslation)) }
        translatedPoints.append(CGPoint(x: imageWidth, y: yTranslation))
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: translatedPoints.first!)
        
        for translatedPoint in translatedPoints {
            bezierPath.addLine(to: translatedPoint)
        }
        
        bezierPath.close()
        
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)
        let context = UIGraphicsGetCurrentContext()
        
//        context?.setFillColor(UIColor.bla.cgColor)
//        UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: imageSize)).fill()
        
        context?.setFillColor(UIColor.white.cgColor)
        
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
