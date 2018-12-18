//
//  LexiqueTableViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 15/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit

class LexiqueTableViewController: UITableViewController {

    private var lexiques: [Lexique] = [];
    
    private let id_cellule          = "celluleLexique";
    private let id_voirTermes       = "voirTermes";
    private let id_editerLexique    = "editerLexique";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            //On crée les tables "lexiques" et "termes" dans le cas où elles n'existeraient pas.
            try LexiqueBDD.createTableIfNotExists();
            TermeBDD.createTableIfNotExists();
        }
        catch {
            print(error);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            //On obtient la liste des lexiques depuis la BDD.
            try lexiques = LexiqueBDD.selectAll();
            tableView.reloadData();
        }
        catch {
            print(error);
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lexiques.count);
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id_cellule, for: indexPath)
        
        let lexique = lexiques[indexPath.row];
        
        cell.textLabel!.text = lexique.getTitre();

        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: id_editerLexique, sender: lexiques[indexPath.row]);
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: id_voirTermes, sender: lexiques[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == id_editerLexique) {
            let destination = segue.destination as! EditerLexiqueViewController;
            
            destination.lexique = (sender as! Lexique);
        }
        else if (segue.identifier == id_voirTermes) {
            let destination = segue.destination as! TermeTableViewController;
            destination.lexique = (sender as! Lexique);
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Cas où on décide de supprimer un lexique
        if editingStyle == .delete {
            let lexique = lexiques[indexPath.row];
            
            //On enclenche la suppresion du lexique de la BDD
            if (LexiqueBDD.delete(lexique: lexique)) {
                
                //Si ça marche, on retire la ligne correspondante de la vue
                lexiques.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @IBAction func boutonEdit(_ sender: Any) {
        self.setEditing(!self.isEditing, animated: true);
    }
}
