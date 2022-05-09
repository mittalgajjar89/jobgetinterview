//
//  TransactionDataManager.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-06.
//

import Foundation
import SQLite3

class TransactionDataManager {
    static func add(transaction: Transaction) -> Int32 {
        let dataBase = SqliteManager.shared.dataBase
        
        //statement pointer
        var statement:OpaquePointer?
        
        let queryString = "INSERT INTO \(TableName.transaction.rawValue) (type,description,amount,date) VALUES (?,?,?,?)"
        
        if sqlite3_prepare(dataBase, queryString, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
            print("error preparing insert: \(errmsg)")
            return 0
        }
        
        var index: Int32 = 1
        sqlite3_bind_text(statement, index, "\(transaction.transactionType ?? 0)".utf8String(), -1, nil)
        
        index += 1
        sqlite3_bind_text(statement, index, (transaction.transactionDescription ?? "").utf8String(), -1, nil)
        
        index += 1
        sqlite3_bind_text(statement, index, "\(transaction.transactionAmount ?? 0)".utf8String(), -1, nil)
        
        index += 1
        sqlite3_bind_text(statement, index, "\(transaction.dateTimeStamp ?? 0)".utf8String(), -1, nil)
        
    
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_step(statement);
            sqlite3_finalize(statement)
            sqlite3_close(dataBase)
            
            return SqliteManager.shared.getLastInsertedId(tableName: TableName.transaction.rawValue)
        } else {
            sqlite3_finalize(statement)
            return 0
        }
    }
    
    
    static func getAll() -> [Transaction] {
        let dataBase = SqliteManager.shared.dataBase

        //statement pointer
        var stmt:OpaquePointer?

        let queryString = String(format: "SELECT id,type,description,amount,date FROM \(TableName.transaction.rawValue) ORDER BY id DESC")


        //preparing the query
        if sqlite3_prepare(dataBase, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
            print("error preparing get: \(errmsg)")
            return []
        }

        var transactions: [Transaction] = []
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let transaction = Transaction()

            transaction.id = Int(sqlite3_column_int(stmt, 0))
            transaction.transactionType = Int(sqlite3_column_int(stmt, 1))
            transaction.transactionDescription = String(cString: sqlite3_column_text(stmt, 2))
            let amountString = String(cString: sqlite3_column_text(stmt, 3))
            transaction.transactionAmount = Float(amountString)
            let dateString = String(cString: sqlite3_column_text(stmt, 4))
            transaction.dateTimeStamp = Double(dateString)
            transactions.append(transaction)
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dataBase)
        
        return transactions
    }
    
    static func delete(transactionId: Int) {
        let dataBase = SqliteManager.shared.dataBase
        
        //statement pointer
        var statement:OpaquePointer?
        
        let queryString = "DELETE FROM \(TableName.transaction.rawValue) WHERE id = '\(transactionId)'"
        
        if sqlite3_prepare(dataBase, queryString, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dataBase)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            sqlite3_step(statement);
            sqlite3_finalize(statement)
            sqlite3_close(dataBase)
            return
        } else {
            sqlite3_finalize(statement)
            return
        }
    }
}

