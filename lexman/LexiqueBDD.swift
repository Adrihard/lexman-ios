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
    
    public static func createTableIfNotExists() {
        do {
            let createTable = table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(titre)
                table.column(descriptif)
            };
            
            try bdd.run(createTable);
        }
        
        catch {
            errorHandling(error: error);
        }
    }
    
    public static func getTermesOfLexique(lexique: Lexique) {
        LexiqueBDD.getTermesOfLexique(id_lexique: lexique.getId()!);
    }
    
    public static func getTermesOfLexique(id_lexique: Int64) {
        
    }
    
    public static func selectAll() -> [Lexique] {
        var lexiques: [Lexique] = [];
        
        do {
            let cursor = try bdd.prepare(table);
            
            for row in cursor {
                lexiques.append(
                    Lexique(
                        id: row[LexiqueBDD.id],
                        titre: row[LexiqueBDD.titre],
                        descriptif: row[LexiqueBDD.descriptif]
                    )
                );
            }
        }
        catch {
            errorHandling(error: error);
        }
        
        return (lexiques);
    }
    
    public static func insertLexique(lexique: Lexique) -> Bool {
        return (
            LexiqueBDD.insertLexique(
                titre: lexique.getTitre(),
                descriptif: lexique.getDescriptif()
            )
        );
    }
    
    public static func insertLexique(titre: String, descriptif: String?) -> Bool {
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
    
    public static func getTermesOfLexique(lexique: Lexique) -> [Terme] {
        var termes: [Terme] = [];
        
        do {
            let join = LexiqueBDD.table.join(
                TermeBDD.table,
                on: LexiqueBDD.id == TermeBDD.lexique
            );
            
            let query = join.select(
                TermeBDD.table[*]
            )
            
            let cursor = try bdd.prepare(query);
            
            for row in cursor {
                termes.append(
                    Terme(
                        id:         row[TermeBDD.id],
                        titre:      row[TermeBDD.titre],
                        descriptif: row[TermeBDD.descriptif]
                    )
                );
            }
        }
        
        catch {
            errorHandling(error: error);
        }
        
        return (termes);
    }
}
