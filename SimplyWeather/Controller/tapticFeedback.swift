//
//  tapticFeedback.swift
//  SimplyWeather
//
//  Created by Tom Dobson on 8/24/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.

import UIKit

extension UIGestureRecognizer {
    
    func tapticFeedback() {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
    }
    
}
