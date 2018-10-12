//
//  Colors.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/12/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit

public extension UIColor {
    /**
     A convenience initializer that creates color from
     argb(alpha red green blue) hexadecimal representation.
     - Parameter argb: An unsigned 32 bit integer. E.g 0xFFAA44CC.
     */
    convenience init(argb: UInt32) {
        let a = argb >> 24
        let r = argb >> 16
        let g = argb >> 8
        let b = argb >> 0
        
        func f(_ v: UInt32) -> CGFloat {
            return CGFloat(v & 0xff) / 255
        }
        
        self.init(red: f(r), green: f(g), blue: f(b), alpha: f(a))
    }
    
    
    /**
     A convenience initializer that creates color from
     rgb(red green blue) hexadecimal representation with alpha value 1.
     - Parameter rgb: An unsigned 32 bit integer. E.g 0xAA44CC.
     */
    convenience init(rgb: UInt32) {
        self.init(argb: (0xff000000 as UInt32) | rgb)
    }
}
