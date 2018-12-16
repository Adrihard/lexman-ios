//
//  Lexique.swift
//  lexman
//
//  Created by Adrian Kalmar on 14/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit

class Lexique{
    
    private var id:         Int64?;
    private var titre:      String;
    private var descriptif: String?;
    
    init(id: Int64?, titre: String, descriptif: String?) {
        self.id         = id;
        self.titre      = titre;
        self.descriptif = descriptif;
    }
    
    public func getId() -> Int64? {
        return (self.id);
    }
    
    public func getTitre() -> String {
        return (self.titre);
    }
    
    public func getDescriptif() -> String? {
        return (self.descriptif);
    }
}
