//
//  ActivityView.swift
//  test
//
//  Created by Ruslan Zinko on 2/2/17.
//  Copyright © 2017 Ruslan Zinko. All rights reserved.
//

import UIKit



class ActivityView: UIView {

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ActivityView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func activityIndicatorStart() {
        
        let gradient = CAGradientLayer()
        gradient.frame = self.activityView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        self.activityView.layer.insertSublayer(gradient, at: 0)
        self.activityView.alpha = 0.5
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if let window = UIApplication.shared.delegate?.window {
            self.frame = UIScreen.main.bounds
            window?.addSubview(self)
        }
    }
    
    func activityIndicatorStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        self.removeFromSuperview()
    }
}
