//
//  UIButtonExtension.swift
//  Game of Life
//
//  Created by Yash  on 02/08/20.
//  Copyright © 2020 Yash . All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.90
        pulse.toValue = 1.0
        pulse.repeatCount = 1.0
        pulse.initialVelocity = 0.5
        pulse.damping = 0
        
        layer.add(pulse, forKey: nil)
    }
}
