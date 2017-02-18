//
//  Db.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//
import Foundation
import GRDB

class Db {
    static func GetDbDirectoryPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static func GetDbFilePath() -> String {
        return GetDbDirectoryPath() + "/credentials.sqlite"
    }
    
    static func isDbFileExists() -> Bool {
        let path  = GetDbFilePath()
        
        let fileManager = FileManager.default
        
        return fileManager.fileExists(atPath: path)
    }
    
    static func CreateDbFile() -> Bool {
        if isDbFileExists() {
            return true
        }
        
        do {
            let dbQueue = try DatabaseQueue(path: GetDbFilePath())
            try dbQueue.inDatabase { db in
                try db.execute(
                    "CREATE TABLE credentials (" +
                        "id INTEGER PRIMARY KEY, " +
                        "email TEXT NOT NULL, " +
                        //"password TEXT NOT NULL, " +
                        "accessToken TEXT NOT NULL, " +
                        "accessTokenCreated DOUBLE NOT NULL, " +
                        "refreshToken TEXT NOT NULL," +
                        "refreshTokenCreated DOUBLE NOT NULL," +
                        "socialToken TEXT NOT NULL, " +
                        "loginType TEXT NOT NULL" +
                    ")"
                )
            }
        }
        catch {
            return false
        }
        
        return true
    }
    
    static func writeCredentials(c : Credentials?) -> Bool {
        if !CreateDbFile() {
            return false
        }
        
        if !isDbFileExists() {
            return false
        }
        
        
        do {
            let dbQueue = try DatabaseQueue(path: GetDbFilePath())
            
            try dbQueue.inDatabase { db in
                try db.execute(
                    "DELETE FROM credentials"
                )
                
                if let cred = c {
                    print("email: " + cred.email)
                    try db.execute(
                        "INSERT INTO credentials (email, accessToken, accessTokenCreated, refreshToken, refreshTokenCreated, socialToken, loginType) " +
                        "VALUES(?, ?, ?, ?, ?, ?, ?)",
                        arguments:  [cred.email,
                                     cred.access_token,
                                     cred.get_access_token_created_unixtime(),
                                     cred.refresh_token,
                                     cred.get_refresh_token_created_unixtime(),
                                     cred.social_token,
                                     cred.loginType.toString()]
                    )
                }
            }
        }
        catch {
            return false
        }
        
        return true
    }
    
    static func readCredentials() -> Credentials? {
        var result : Credentials? = nil
        
        if !CreateDbFile() {
            return result
        }
        
        do {
            let dbQueue = try DatabaseQueue(path: GetDbFilePath())
            
            try dbQueue.inDatabase { db in
                let rows = try Row.fetchAll(db, "SELECT * FROM credentials")
                if rows.count > 0 {
                    let row = rows[0]
                    let cred = Credentials()
                    cred.access_token = row.value(named: "accessToken")
                    cred.set_access_token_created_from_unixtime(unixtime: row.value(named: "accessTokenCreated"))
                    cred.refresh_token = row.value(named: "refreshToken")
                    cred.set_refresh_token_created_from_unixtime(unixtime: row.value(named: "refreshTokenCreated"))
                    cred.email = row.value(named: "email")
                    cred.social_token = row.value(named: "socialToken")
                    cred.loginType = LoginType.fromString(s: row.value(named: "loginType"))
                    result = cred
                }
            }
        }
        catch {
            
        }
        return result
    }
    
    static func isAuthorized() -> Bool {
        return readCredentials() != nil
    }
}
