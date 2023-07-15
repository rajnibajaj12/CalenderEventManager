//
//  CustomClass.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 11/07/23.
//

import Foundation
import UIKit
extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
   
    func setRightViewIcon(image: UIImage){
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.frame = CGRect(x: 15, y: 17, width: 25, height: 25)
        //For Setting extra padding other than Icon.
        let seperatorView = UIView(frame: CGRect(x: 23, y: 0, width: 10, height: 50))

        view.addSubview(seperatorView)
        self.rightViewMode = .always
        view.addSubview(imageView)
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = view
    }
}
