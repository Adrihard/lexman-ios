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
                //Le nom de la ligne s'affiche en rouge si le nom du lexique n'est pas renseigné.
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
            
            //Cas où on valide la création du lexique.
            case "validerCreationLexique":
                
                //On vérifie qu'il n'y a pas d'erreurs dans le formulaire.
                if (self.form.validate().isEmpty) {
                    
                    //Si tout est bon, on récupère les valeurs qui nous intéressent.
                    let values = self.form.values();
                    let titre = values[id_titre];
                    let descriptif  = values[id_descriptif];
                    
                    //On s'assure que le titre est bien présent
                    //(c'est redondant avec la règle du formulaire, mais on sait jamais).
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
