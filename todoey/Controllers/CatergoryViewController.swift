//
//  CatergoryViewController.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-07-06.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import UIKit
import RealmSwift

class CatergoryViewController: UITableViewController {

    let realm = try! Realm()
    var catergoryArray : Results<catergory>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("catergory.plist")
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatergory()
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catergoryCell", for: indexPath)
        
        
        
        cell.textLabel?.text = catergoryArray?[indexPath.row].name ?? "No Catergories Added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catergoryArray?.count ?? 1 //if not nill return catergories.count else return one
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCatergory = catergoryArray?[indexPath.row]
            
            
            //get the index for the selected cell
            
        }
        
    }

    @IBAction func addyButtonPressed(_ sender: UIBarButtonItem) {
        
            
            var textField = UITextField()
            
            
            let alert = UIAlertController.init(title: "Add New Catergory", message: "Please type in the catergory you would like added to your list.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                
                let newItem = catergory()
                newItem.name = textField.text!
                self.save(catergory: newItem)
            }
            alert.addAction(action)
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Enter a new Catergory"
                
                textField = alertTextField
            }
            
            present(alert, animated: true, completion: nil)
        }
    
    
    func save(catergory: catergory){
        
        do {
            try realm.write{
                realm.add(catergory)
                
            }
        }
        catch {
            print("error saving the context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCatergory(){
        
        catergoryArray = realm.objects(catergory.self)
       
        tableView.reloadData()
    }
}

