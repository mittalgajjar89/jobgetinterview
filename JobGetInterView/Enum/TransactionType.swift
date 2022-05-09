//
//  TransactionType.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-06.
//

import Foundation
enum TransactionType: Int, CaseIterable {
    case expense
    case income
    
    func getTitle() -> String {
        switch self {
        case .expense:
            return "Expense"
        case .income:
            return "Income"
        }
    }
}
