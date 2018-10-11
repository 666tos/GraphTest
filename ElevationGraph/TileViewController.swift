//
//  TileViewController.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/20/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

class TileViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var contentView: TiledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let points = GraphMaskGenerator.generatePoints(1000000).data
        
        self.measure({
            var maxPointX = -CGFloat.infinity
            
            for point in points {
                if (point.x > maxPointX) {
                    maxPointX = point.x
                }
            }
            print("maxPointX: \(maxPointX)")
        }, name: "Enumeration")
        
        self.measure({
            var maxPointX = -CGFloat.infinity
            
            for i in 0 ..< points.count {
                let point = points[i]
                if (point.x > maxPointX) {
                    maxPointX = point.x
                }
            }
            print("maxPointX: \(maxPointX)")
        }, name: "For i")
        
        self.measure({
            var maxPointX = -CGFloat.infinity
            
            points.forEach {
                if ($0.x > maxPointX) {
                    maxPointX = $0.x
                }
            }
            print("maxPointX: \(maxPointX)")
        }, name: "Foreach")
      
//        let maskImage = GraphMaskGenerator().image
//        let maskImageView = UIImageView(frame: self.contentView!.bounds)
//        maskImageView.backgroundColor = UIColor.clear
//        maskImageView.image = maskImage
        
//        self.contentView.mask = maskImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func measure(_ block: ()-> (), name: String) {
        let startTimestamp = Date().timeIntervalSince1970
        block()
        let finishTimestamp = Date().timeIntervalSince1970
        print("Operation \"\(name)\" took: \(finishTimestamp - startTimestamp)")
    }
}

extension TileViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
}
