//
//  TermeTableViewController.swift
//  lexman
//
//  Created by Adrian Kalmar on 18/12/2018.
//  Copyright © 2018 Adrian Kalmar. All rights reserved.
//

import UIKit

class TermeTableViewController: UITableViewController {

    var termes: [Terme] = [];
    
    let idCellule = "celluleTerme";
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (termes.count);
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCellule, for: indexPath)
        
        let terme = termes[indexPath.row];
        
        cell.textLabel!.text = terme.getTitre();
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "editerTerme", sender: termes[indexPath.row]);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editerTerme") {
            let destination = segue.destination as! EditerTermeViewController;
            
            destination.terme = (sender as! Terme);
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Cas où on décide de supprimer un terme
        if editingStyle == .delete {
            let terme = termes[indexPath.row];
            
            //On enclenche la suppresion du lexique de la BDD
            if (TermeBDD.delete(terme: terme)) {
                
                //Si ça marche, on retire la ligne correspondante de la vue
                termes.remove(at: indexPath.row);
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    @IBAction func boutonEdit(_ sender: Any) {
        self.setEditing(!self.isEditing, animated: true);
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    
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
    
    

}
