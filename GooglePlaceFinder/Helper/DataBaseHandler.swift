//
//  DBHandler.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    
    private let path = AppConstants.databaseName
    private var database: OpaquePointer?

    init() {
        database = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(path)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            debugPrint("error opening database")
            return nil
        }
        else
        {
            debugPrint("Successfully opened connection to database at \(path)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS place(placeId INTEGER PRIMARY KEY,name TEXT, latitude INTEGER, longitude INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                debugPrint("place table created.")
            } else {
                debugPrint("place table could not be created.")
            }
        } else {
            debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(name: String, latitude: Double, longitude: Double) {
        let places = read()
        for p in places { if p.placeID == 0 { return } }
        let insertStatementString = "INSERT INTO place (placeID, name, latitude, longitude) VALUES (NULL, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 2, Double(latitude))
            sqlite3_bind_double(insertStatement, 3, Double(longitude))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                debugPrint("Successfully inserted row.")
            } else {
                debugPrint("Could not insert row.")
            }
        } else {
            debugPrint("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Places] {
        let queryStatementString = "SELECT * FROM place;"
        var queryStatement: OpaquePointer? = nil
        var place : [Places] = []
        if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let placeID = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let latitude = sqlite3_column_double(queryStatement, 2)
                let longitude = sqlite3_column_double(queryStatement, 3)
                place.append(Places(name: name, placeID: Int(placeID), latitude: Double(latitude), longitude: Double(longitude)))
            }
        } else {
            debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return place
    }
}
