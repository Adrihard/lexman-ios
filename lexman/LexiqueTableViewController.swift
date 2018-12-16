//
//  LexiqueTableViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 15/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit

class LexiqueTableViewController: UITableViewController {

    var lexiques: [Lexique] = [];
    
    let idCellule = "celluleLexique";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On crée les tables "lexiques" et "termes" dans le cas où elles n'existeraient pas.
        LexiqueBDD.createTableIfNotExists();
        TermeBDD.createTableIfNotExists();
        
        //On obtient la liste des lexiques depuis la BDD.
        lexiques = LexiqueBDD.selectAll();
        
        //On ajoute le bouton Edit qui permettra de supprimer des lexiques.
        navigationItem.leftBarButtonItem = editButtonItem;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lexiques.count);
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCellule, for: indexPath)
        
        let lexique = lexiques[indexPath.row];
        
        cell.textLabel!.text = lexique.getTitre();

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Cas où on décide de supprimer un lexique
        if editingStyle == .delete {
            let lexique = lexiques[indexPath.row];
            
            //On enclenche la suppresion du lexique de la BDD
            if (LexiqueBDD.deleteLexique(lexique: lexique)) {
                
                //Si ça marche, on retire la ligne correspondante de la vue
                lexiques.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
