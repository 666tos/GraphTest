//
//  TiledView.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/20/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

class TiledView: UIView {
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var tiledLayer: CATiledLayer {
        guard let tiledLayer = self.layer as? CATiledLayer else {
            fatalError()
        }
        
        return tiledLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tiledLayer.drawsAsynchronously = true
        self.tiledLayer.tileSize = CGSize(width: 256, height: self.bounds.size.height)
        self.tiledLayer.levelsOfDetailBias = 8
    }
    
    var points: Points = ([], 0, 0) {
        didSet {
//            layer.tileSize = CGSize(width: sideLength, height: sideLength)
        }
    }
    
    private func getPoints(_ rect: CGRect) -> [CGPoint] {
        let minX = self.points.data.first!.x
        let maxX = self.points.data.last!.x
        
        let relativeStart = rect.minX / self.bounds.size.width
        let relativeEnd = rect.maxX / self.bounds.size.width
        
        let someMargin = CGFloat(20)
        let start = minX + relativeStart * (maxX - minX) - someMargin
        let end = minX + relativeEnd * (maxX - minX) + someMargin
        
        return self.points.data.filter { ($0.x >= start) && ($0.x <= end) }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let pointsToDraw = getPoints(rect)
        
        let imageWidth = self.bounds.size.width
        let imageHeight = self.bounds.size.height
        
        let minX = self.points.data.first!.x
        let maxX = self.points.data.last!.x
        
        let xScale = imageWidth / (maxX - minX)
        let xTranslation = minX
        
        let maxDelta = max(self.points.min.magnitude, self.points.max.magnitude)
        let yScale = imageHeight / (2 * maxDelta)
        let yTranslation = imageHeight / 2
        
        let firstPoint = pointsToDraw.first!
        let lastPoint = pointsToDraw.last!
        
        var translatedPoints: [CGPoint] = [CGPoint(x: (firstPoint.x - xTranslation) * xScale, y: yTranslation)]
        pointsToDraw.forEach { translatedPoints.append(CGPoint(x: ($0.x - xTranslation) * xScale, y: $0.y * yScale + yTranslation)) }
        translatedPoints.append(CGPoint(x: (lastPoint.x - xTranslation) * xScale, y: yTranslation))
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: translatedPoints.first!)
        
        for translatedPoint in translatedPoints {
            bezierPath.addLine(to: translatedPoint)
        }
        
        bezierPath.close()
        
        context.setFillColor(UIColor.white.cgColor)
        
        context.addPath(bezierPath.cgPath)
        context.fillPath(using: .winding)
    }
}
