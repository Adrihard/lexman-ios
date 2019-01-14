//
//  EditerLexiqueViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 15/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import Eureka

class EditerLexiqueViewController: FormViewController {
    
    private let id_titre            = "titreLexique";
    private let id_descriptif       = "descriptifLexique";
    
    @IBOutlet var navigatonItem: UINavigationItem!
    
    public  var lexique: Lexique?   = nil;
    
    private var valide_titre = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationItem.title = (lexique == nil)
            ? "Nouveau lexique"
            : "Détails du lexique";
        
        form
            +++ Section("Infos de base")
                <<< TextRow(id_titre){
                    $0.title       = "Nom";
                    $0.placeholder = "Obligatoire";
                    $0.value       = lexique?.getTitre();
                    $0.add(rule: RuleRequired());
                    $0.validationOptions = .validatesOnChange;
                }
                //Le nom de la ligne s'affiche en rouge si le nom du lexique n'est pas renseigné.
                .cellUpdate { cell, row in
                    self.valide_titre = row.isValid;
                    self.updateSaveButton();
                    if (!row.isValid) {
                        cell.titleLabel?.textColor = .red
                    }
                }
            +++ Section("Infos supplémentaires")
                <<< TextAreaRow(id_descriptif) {
                    $0.title       = "Description";
                    $0.placeholder = "Vous pouvez mettre une description"
                    $0.value = lexique?.getDescriptif();
                }
    }
    
    @IBAction func boutonCancel(_ sender: Any) {
        //On se contente de fermer la vue.
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func boutonSave(_ sender: Any) {
        //On vérifie qu'il n'y a pas d'erreurs dans le formulaire.
        if (self.form.validate().isEmpty) {
            
            //Si tout est bon, on récupère les valeurs qui nous intéressent.
            let values = self.form.values();
            let titre = values[id_titre];
            let descriptif  = values[id_descriptif];
            
            //On s'assure que le titre est bien présent
            //(c'est redondant avec la règle du formulaire, mais on sait jamais).
            if (titre != nil) {
                
                //Si aucun lexique n'a été passé, c'est qu'on est en train de créer un nouveau.
                //Dans ce cas, on lance une insertion
                if (lexique == nil) {
                    if (LexiqueBDD.insert(
                        titre: titre as! String,
                        descriptif: descriptif as! String?
                    )) {
                        //Si l'insertion fonctionne, on peut fermer cette vue.
                        self.navigationController!.popViewController(animated: true)
                    };
                }
                    
                //Sinon, c'est qu'on cherche à mettre à jour un lexique déjà existant.
                else {
                    if (LexiqueBDD.update(
                        id:         lexique!.getId(),
                        titre:      titre as! String,
                        descriptif: descriptif as! String?
                    )) {
                        //Si la mise à jour fonctionne, on peut fermer cette vue.
                        self.navigationController!.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    private func updateSaveButton() {
        self.navigationItem.rightBarButtonItem!.isEnabled = self.valide_titre;
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
