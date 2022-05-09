//
//  ProgressBarView.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import UIKit

class ProgressBarView: UIView {
    
    var contentView: UIView!
    @IBOutlet weak var progressBar:UIProgressView!
    
    var progress: Float = 0.0 {
        didSet {
            progressBar.progress = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        contentView = setup()
    }
}
