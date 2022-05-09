//
//  ListExpensesTableViewCell.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import UIKit

class ListExpensesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listExpenseTitle: UILabel!
    @IBOutlet weak var listExpensePrice: UILabel!
    
    static var nibName = "ListExpensesTableViewCell"
    
    var title: String = "" {
        didSet {
            listExpenseTitle.text = title
        }
    }
    
    var price: String = "" {
        didSet {
            listExpensePrice.text = price
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
