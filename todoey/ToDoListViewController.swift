//
//  ViewController.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-06-14.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike","Buy Eggos", "Destroy the Thinker"]
    
    let defaults = UserDefaults.standard// Stores key value pairs consistently
    
    //let defaults2 = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = item
        }
        
        else if  let item2 = defaults.array(forKey: "motherTrucker") as? [String]{
            itemArray = item2
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Populating the current index path
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK TableViewMethod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func ToDoAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add New ToDoEh Item", message: "Please type in below your new task you would like added to your list.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            self.itemArray.append(textField.text!)
            //what would happen when the user clicks the add item button on our UI Alert
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new Item"
            
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        let alert2 = UIAlertController.init(title: "Delete all entries?", message: "Are you sure you want to clear everything?", preferredStyle: .alert)
        
        let action2 = UIAlertAction(title: "Delete all entries", style: .default) { (action) in
            self.itemArray.removeAll()
            
            self.defaults.set(self.itemArray, forKey: "motherTrucker")
           
            self.tableView.reloadData()
            
            
        }
        alert2.addAction(action2)
        present(alert2, animated: true, completion: nil)
        
        
    }
    
}
