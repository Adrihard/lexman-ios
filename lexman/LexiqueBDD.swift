//
//  LexiqueBDD.swift
//  lexman
//
//  Created by Adrian Kalmar on 15/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import SQLite

class LexiqueBDD {
    private static var bdd = BDD.getConnection();
    
    public static let table       = Table("lexiques");
    
    public static let id          = Expression<Int64>("id");
    public static let titre       = Expression<String>("titre");
    public static let descriptif  = Expression<String?>("descriptif");
    
    private init() {}
    
    private static func errorHandling(error: Error) {
        print(error);
    }
    
    public static func createTableIfNotExists() throws {
        let createTable = table.create(ifNotExists: true) { table in
            table.column(id, primaryKey: .autoincrement)
            table.column(titre)
            table.column(descriptif)
        };
            
        try bdd.run(createTable);
    }
    
    public static func selectAll() throws -> [Lexique] {
        let cursor = try bdd.prepare(table);
        
        var lexiques: [Lexique] = [];
        
        for row in cursor {
            lexiques.append(
                Lexique(
                    id: row[LexiqueBDD.id],
                    titre: row[LexiqueBDD.titre],
                    descriptif: row[LexiqueBDD.descriptif]
                )
            );
        }
        
        return (lexiques);
    }
    
    public static func insert(lexique: Lexique) -> Bool {
        return (
            LexiqueBDD.insert(
                titre: lexique.getTitre(),
                descriptif: lexique.getDescriptif()
            )
        );
    }
    
    public static func insert(titre: String, descriptif: String?) -> Bool {
        do {
            let insert = LexiqueBDD.table.insert(
                LexiqueBDD.titre <- titre,
                LexiqueBDD.descriptif <- descriptif
            );
            
            try bdd.run(insert);
            return (true);
        }
            
        catch {
            errorHandling(error: error)
        }
        
        return (false);
    }
    
    public static func update(id: Int64?, titre: String, descriptif: String?) -> Bool {
        let lexique = LexiqueBDD.ligne(id: id);
        
        if (lexique != nil) {
            do {
                try LexiqueBDD.bdd.run(lexique!.update(
                    LexiqueBDD.titre <- titre,
                    LexiqueBDD.descriptif <- descriptif
                ));
                
                return (true);
            }
            catch {
                errorHandling(error: error);
            }
        }
        
        return (false);
    }
    
    public static func delete(lexique: Lexique) -> Bool {
        return (LexiqueBDD.delete(id: lexique.getId()));
    }
    
    public static func delete(id: Int64?) -> Bool {
        let lexique = LexiqueBDD.ligne(id: id);
        
        if (lexique != nil) {
            do {
                try LexiqueBDD.bdd.run(lexique!.delete());
                return (true);
            }
            catch {
                errorHandling(error: error);
            }
        }
        
        return (false);
    }
    
    public static func exists(lexique: Lexique) throws -> Bool {
        return (try LexiqueBDD.exists(id: lexique.getId()));
    }
    
    public static func exists(id: Int64?) throws -> Bool {
        let lexique = LexiqueBDD.ligne(id: id);
        
        if (lexique != nil) {
            let count = try LexiqueBDD.bdd.scalar(lexique!.count);
            return (count > 0);
        }
        
        return (false);
    }
    
    public static func getTermes(lexique: Lexique) throws -> [Terme] {
        let join = LexiqueBDD.table.join(
            TermeBDD.table,
            on: LexiqueBDD.id == TermeBDD.lexique
        );
            
        let query = join.select(
            TermeBDD.table[*]
        )
        
        let cursor = try bdd.prepare(query);
        
        var termes: [Terme] = [];
        
        for row in cursor {
            termes.append(Terme(
                id:         row[TermeBDD.id],
                titre:      row[TermeBDD.titre],
                descriptif: row[TermeBDD.descriptif]
            ));
        }
        
        return (termes);
    }

    private static func ligne(id: Int64?) -> Table? {
        if (id != nil && id! >= 0) {
            return (LexiqueBDD.table.filter(LexiqueBDD.id == id!));
        }
        return (nil);
    }
}
