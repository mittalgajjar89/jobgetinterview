//
//  AddTransactionViewModel.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import Foundation
class AddTransactionViewModel {
    var transaction = Transaction()
    
    func setTransactionType(type: Int) {
        transaction.transactionType = type
    }
    
    func getTransactionType() -> Int? {
        return transaction.transactionType
    }
    
    func addTransaction(amount: Float, description: String) -> Bool {
        transaction.transactionDescription = description
        transaction.transactionAmount = amount
        transaction.dateTimeStamp = Date().timeIntervalSince1970
        return (TransactionDataManager.add(transaction: transaction) > 0)
    }
}
