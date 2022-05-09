//
//  UIView+Extension.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import Foundation
import UIKit
extension UIView {
    func loadViewFromNib() -> UIView { // grabs the appropriate bundle
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(type(of: self))", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setup(_ shouldUseConstraint: Bool = false) -> UIView {
        //setup the view from .xib
        let contentView = loadViewFromNib()
        contentView.frame = self.bounds
        if shouldUseConstraint {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            let contentViewConstraints: [NSLayoutConstraint] = [
                NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            ]
            self.addConstraints(contentViewConstraints)
        } else {
            contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(contentView)
        }
        
        return contentView
    }
}
