//
//  FloatingPoint+Extension.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 9/21/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation

extension FloatingPoint {
    public func mod(by other: Self) -> Self {
        let r = self.remainder(dividingBy: other)
        return r >= 0 ? r : r + other
    }
}
