//
//  ExtensionViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

extension UIViewController {
    enum Tags: Int {
        case indicator = 9999
    }
}

extension UIViewController {
    
    func showIndicator(color: UIColor = .black) {

        if self.view.viewWithTag(Tags.indicator.rawValue) != nil {
            return
        }
        
        let bounds = self.view.bounds
        let view = UIView(frame: bounds)
        view.tag = Tags.indicator.rawValue
        view.backgroundColor = .gray
        view.alpha = 0.5
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = color
        indicator.center = view.center
        indicator.startAnimating()
        
        view.addSubview(indicator)
        self.view.addSubview(view)
    }
    
    func hideIndicator() {
        
        guard let view = self.view.viewWithTag(Tags.indicator.rawValue) else {
            return
        }
        view.removeFromSuperview()
    }
}

extension UIViewController {

    func displayAlert(title: String, message: String) {
        
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        
        present(alert, animated: true, completion: nil)
    }

}

