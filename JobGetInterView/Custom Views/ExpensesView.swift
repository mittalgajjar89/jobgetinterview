//
//  ExpensesView.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import UIKit

class ExpensesView: UIView {
    
    var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    @IBInspectable var showSeperator: Bool = true {
        didSet {
            seperatorView.isHidden = !showSeperator
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var price: Float = 0.0 {
        didSet {
            if price < 0 {
                priceLabel.text = String(format: "-$%.2f", price)
            } else {
                priceLabel.text = String(format: "$%.2f", price)
            }
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
