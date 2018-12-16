//
//  AjouterLexiqueViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 15/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import Eureka

class AjouterLexiqueViewController: FormViewController {

    private let id_titre          = "titreLexique";
    private let id_descriptif   = "descriptifLexique";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section("Infos de base")
                <<< TextRow(id_titre){
                    $0.title       = "Nom"
                    $0.placeholder = "Obligatoire"
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if (!row.isValid) {
                        cell.titleLabel?.textColor = .red
                    }
                }
            +++ Section("Infos supplémentaires")
                <<< TextAreaRow(id_descriptif) {
                    $0.title       = "Description"
                    $0.placeholder = "Vous pouvez mettre une description"
                }

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch (identifier) {
            case "validerCreationLexique":
                if (self.form.validate().isEmpty) {
                    let values = self.form.values();
                    
                    let titre = values[id_titre];
                    let descriptif  = values[id_descriptif];
                    
                    if (titre != nil) {
                        return (
                            LexiqueBDD.insertLexique(
                                titre: titre as! String,
                                descriptif: descriptif as! String?
                            )
                        );
                    }
                }
                return (false);
            
            default:
                return (true);
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
