//
//  SqliteManager.swift
//  JobGetInterView
//
//  Created by Mittal  gajjar on 2022-05-06.
//

import Foundation
import SQLite3

enum TableName: String {
    case transaction = "tbl_transaction"
}
class SqliteManager {
    static var shared = SqliteManager()
    
    var dataBase: OpaquePointer? {
        return self.openDatabase()
    }
    
    var dataBaseName = "db_jobget.sqlite"
    
    func openDatabase() -> OpaquePointer? {
        checkAndCopyDataBaseFile()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dataBaseName)
        var db: OpaquePointer? = nil
        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            //print("Successfully opened connection to database at \(fileURL.path)")
            return db
        }
        return nil
    }
    
    func checkAndCopyDataBaseFile() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dataBaseName)
        print(fileURL)
        let filemanager = FileManager.default
        if !filemanager.fileExists(atPath: fileURL.path) {
            let localDBPath = Bundle.main.path(forResource: "db_jobget", ofType: "sqlite")
            try! filemanager.copyItem(at: URL(fileURLWithPath: localDBPath!), to: fileURL)
        }
    }
    
    func removeLocalDBFile() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dataBaseName)
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: fileURL.path) {
            do {
                try filemanager.removeItem(atPath: fileURL.path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getLastInsertedId(tableName: String) -> Int32 {
        let localDataBase = SqliteManager.shared.dataBase
        
        //statement pointer
        var stmt:OpaquePointer?
        
        let queryString = "SELECT id from \(tableName) order by ROWID DESC limit 1"
        
        //preparing the query
        if sqlite3_prepare(localDataBase, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(localDataBase)!)
            print("error preparing insert: \(errmsg)")
            return 0
        }
        
        //traversing through all the records
        var id: Int32 = 0
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            id = sqlite3_column_int(stmt, 0)
        }
        sqlite3_finalize(stmt)
        sqlite3_close(localDataBase)
        
        return id
    }
}
