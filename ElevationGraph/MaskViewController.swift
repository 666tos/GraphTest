//
//  ViewController.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/18/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {
    struct Constant {
        static let updateInterval = TimeInterval(1)
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var contentView: FillView!
    
    let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskImage = GraphMaskGenerator().image
        let maskImageView = UIImageView(frame: self.contentView!.bounds)
        maskImageView.backgroundColor = UIColor.clear
        maskImageView.image = maskImage
        
        self.contentView.mask = maskImageView
        
        self.timer.schedule(deadline: .now() + Constant.updateInterval, repeating: Constant.updateInterval)
        self.timer.setEventHandler {
            if (self.contentView.progress == 1) {
                self.contentView.progress = 0
            }
            else {
                self.contentView.progress += 0.05
            }
        }
        self.timer.resume()
    }
}

extension MaskViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
}

