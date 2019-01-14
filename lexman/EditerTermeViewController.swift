//
//  EditerTermeViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 18/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit
import Eureka

class EditerTermeViewController: FormViewController {

    private let id_titre            = "titreTerme";
    private let id_descriptif       = "descriptifTerme";
    
    private var atLaunch            = true;
    
    @IBOutlet var navigatonItem: UINavigationItem!
    
    public  var lexique:    Lexique?    = nil;
    public  var terme:      Terme?      = nil;
    
    private var valide_titre            = false;
    private var valide_descriptif       = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = (terme == nil)
            ? "Nouveau terme"
            : "Détails du terme";
        
        form
            +++ Section("Infos de base")
            <<< TextRow(id_titre){
                $0.title       = "Nom";
                $0.placeholder = "Obligatoire";
                $0.value       = terme?.getTitre();
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
                $0.title       = "Définition";
                $0.placeholder = "Entrez votre définition ici"
                $0.value = terme?.getDescriptif();
                $0.add(rule: RuleRequired());
                $0.validationOptions = .validatesOnChange;
            }
            .cellUpdate { cell, row in
                self.valide_descriptif = row.isValid;
                self.updateSaveButton();
            }
    }
    
    @IBAction func boutonSave(_ sender: Any) {
        //On vérifie qu'il n'y a pas d'erreurs dans le formulaire.
        if (self.form.validate().isEmpty) {
            
            //Si tout est bon, on récupère les valeurs qui nous intéressent.
            let values = self.form.values();
            let titre = values[id_titre];
            let descriptif  = values[id_descriptif];
            
            //On s'assure qu'on a toutes les infos nécessaires
            //(c'est redondant avec les règles du formulaire, mais on sait jamais).
            if (titre != nil && descriptif != nil) {
                
                //Si aucun terme n'a été passé, c'est qu'on est en train de créer un nouveau.
                //Dans ce cas, on lance une insertion
                if (terme == nil) {
                    if (TermeBDD.insert(
                        titre: titre as! String,
                        descriptif: descriptif as! String,
                        id_lexique: lexique!.getId()
                    )) {
                        //Si l'insertion fonctionne, on peut fermer cette vue.
                        self.navigationController?.popViewController(animated: true);
                    }
                }
                    
                //Sinon, c'est qu'on cherche à mettre à jour un terme déjà existant.
                else if (TermeBDD.update(
                    id:         terme!.getId(),
                    titre:      titre as! String,
                    descriptif: (descriptif as! String))
                ) {
                    //Si la mise à jour fonctionne, on peut fermer cette vue.
                    self.navigationController?.popViewController(animated: true);
                }
            }
        }
    }
    
    @IBAction func boutonCancel(_ sender: Any) {
        //On se contente de fermer la vue.
        self.navigationController?.popViewController(animated: true);
    }
    
    private func updateSaveButton() {
        self.navigationItem.rightBarButtonItem!.isEnabled = self.valide_titre && self.valide_descriptif;
    }
}
