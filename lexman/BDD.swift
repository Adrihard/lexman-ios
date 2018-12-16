//
//  BDD.swift
//  lexman
//
//  Created by Adrian Kalmar on 14/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import SQLite

class BDD {
    private static let instance = BDD();
    
    private var database: Connection!
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!;
        
        do {
            self.database = try Connection("\(path)/db.sqlite3");
        }
        catch {
            print(error);
        }
    }
    
    public static func getConnection() -> Connection {
        return (instance.database);
    }
}
