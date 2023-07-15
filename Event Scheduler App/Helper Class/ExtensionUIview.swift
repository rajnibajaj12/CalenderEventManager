//
//  ExtensionUIview.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 13/07/23.
//

import Foundation
import UIKit
import AudioToolbox
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        self.viewContainingController?.vibrate()
    }
}


extension UIViewController {
    func vibrate(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
