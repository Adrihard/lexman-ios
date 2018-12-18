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
    
    public static func insert(terme: Terme, lexique: Lexique) -> Bool {
        return (
            TermeBDD.insert(
                titre: terme.getTitre(),
                descriptif: terme.getDescriptif(),
                id_lexique: lexique.getId()
            )
        );
    }
    
    public static func insert(titre: String, descriptif: String, id_lexique: Int64?) -> Bool {
        if (id_lexique != nil && id_lexique! >= 0) {
            do {
                let insert = TermeBDD.table.insert(
                    TermeBDD.titre <- titre,
                    TermeBDD.descriptif <- descriptif,
                    TermeBDD.lexique <- id_lexique!
                );
                
                try bdd.run(insert);
                return (true);
            }
                
            catch {
                errorHandling(error: error)
            }
        }
        return (false);
    }
    
    public static func update(id: Int64?, titre: String, descriptif: String) -> Bool {
        let terme = TermeBDD.ligne(id: id);
        
        if (terme != nil) {
            do {
                try TermeBDD.bdd.run(terme!.update(
                    TermeBDD.titre <- titre,
                    TermeBDD.descriptif <- descriptif
                ));
                
                return (true);
            }
            catch {
                errorHandling(error: error);
            }
        }
        
        return (false);
    }
    
    public static func delete(terme: Terme) -> Bool {
        return (TermeBDD.delete(id: terme.getId()));
    }
    
    public static func delete(id: Int64?) -> Bool {
        let terme = TermeBDD.ligne(id: id);
        
        if (terme != nil) {
            do {
                try TermeBDD.bdd.run(terme!.delete());
                return (true);
            }
            catch {
                errorHandling(error: error);
            }
        }
        
        return (false);
    }
    
    private static func ligne(id: Int64?) -> Table? {
        if (id != nil && id! >= 0) {
            return (TermeBDD.table.filter(TermeBDD.id == id!));
        }
        return (nil);
    }
}
