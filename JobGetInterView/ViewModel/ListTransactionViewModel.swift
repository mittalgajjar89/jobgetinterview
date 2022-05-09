//
//  ListTransactionViewModel.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-05.
//

import Foundation

class ListTransactionViewModel {
    
    var transactions: [Transaction] = []
    var dateTransactionsMap: [String: [Transaction]] = [:]
    var totalIncome: Float = 0
    var totalExpense: Float = 0
    var transationDates: [String] = []
    var expenseBarValue: Float {
        return (totalIncome > 0) ? totalExpense/totalIncome : 0
    }
    
    func fetchData() {
        transactions = TransactionDataManager.getAll()
        groupTransactions()
    }
    
    func groupTransactions() {
        dateTransactionsMap.removeAll()
        totalIncome = 0
        totalExpense = 0
        
        let dateFormatter = DateFormatter()
    
        for i in 0 ..< transactions.count {
            let transaction = transactions[i]
            let date =  Date(timeIntervalSince1970: transaction.dateTimeStamp ?? 0)
            dateFormatter.dateFormat = date.dateFormatWithSuffix()
            let dateString = dateFormatter.string(from: date)
            if dateTransactionsMap[dateString] != nil {
                dateTransactionsMap[dateString]!.append(transaction)
            } else {
                dateTransactionsMap[dateString] = [transaction]
                transationDates.append(dateString)
            }
            if transaction.transactionType == TransactionType.expense.rawValue {
                totalExpense = totalExpense + (transaction.transactionAmount ?? 0)
            } else {
                totalIncome = totalIncome + (transaction.transactionAmount ?? 0)
            }
        }
    }
    
    func getNumberOfRows(sectionNumber: Int) -> Int {
        let transactionDate = transationDates[sectionNumber]
        let transactions = dateTransactionsMap[transactionDate] ?? []
        return transactions.count + 1
    }
    
    func getNumberOfSection() -> Int {
        return dateTransactionsMap.count
    }
    
    func canDeleteRow(at indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func deleteRow(at indexPath: IndexPath) {
        let transactionDate = transationDates[indexPath.section]
        let transactions = dateTransactionsMap[transactionDate] ?? []
        let transaction = transactions[indexPath.row - 1]
        TransactionDataManager.delete(transactionId: transaction.id ?? 0)
    }
    
    func getTitle(indexPath: IndexPath) -> String {
        let transactionDate = transationDates[indexPath.section]
        if indexPath.row == 0 {
            return transactionDate
        }
        let transactions = dateTransactionsMap[transactionDate] ?? []
        let transaction = transactions[indexPath.row - 1]
        
        return transaction.transactionDescription ?? ""
    }
    
    func getPrice(indexPath: IndexPath) ->String {
        let transactionDate = transationDates[indexPath.section]
        if indexPath.row == 0 {
            return ""
        }
        let transactions = dateTransactionsMap[transactionDate] ?? []
        let transaction = transactions[indexPath.row - 1]
        let amount = transactions[indexPath.row - 1].transactionAmount ?? 0
        if transaction.transactionType ?? 0 == TransactionType.expense.rawValue {
            return String(format: "-$%.2f", amount)
        }
        return String(format: "$%.2f", amount)
    }
}
