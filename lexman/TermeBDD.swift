//
//  TermeBDD.swift
//  lexman
//
//  Created by Adrian Kalmar on 14/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import SQLite

class TermeBDD {
    private static var bdd = BDD.getConnection();
    
    public static let table         = Table("termes");
    
    public static let id            = Expression<Int64>("id");
    public static let titre         = Expression<String>("titre");
    public static let descriptif    = Expression<String>("descriptif");
    public static let lexique       = Expression<Int64>("id_lexique");
    
    private init() {}
    
    private static func errorHandling(error: Error) {
        print(error);
    }
    
    public static func createTableIfNotExists() {
        do {
            let createTable = TermeBDD.table.create(ifNotExists: true) { table in
                table.column(TermeBDD.id, primaryKey: .autoincrement)
                table.column(TermeBDD.titre)
                table.column(TermeBDD.descriptif)
                table.column(TermeBDD.lexique)
                table.foreignKey(TermeBDD.lexique, references: TermeBDD.table, TermeBDD.id, delete: .cascade)
            };
            
            try bdd.run(createTable);
        }
        
        catch {
            errorHandling(error: error);
        }
    }
}
