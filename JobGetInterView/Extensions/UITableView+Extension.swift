//
//  UITableView+Extension.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import Foundation
import UIKit
extension UITableView {
    
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        let identifier = String(describing: cellClass.self)
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell> (_ cellClass: T.Type, indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass.self)
        if let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
            return cell
        }
        fatalError()
    }
}
