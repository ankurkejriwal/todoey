//
//  ViewController.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-06-14.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [customDataModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print (dataFilePath)
        let newItem = customDataModel()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        loadItems()
        
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Populating the current index path
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let itemz = itemArray[indexPath.row]

        cell.accessoryType = itemz.checkmark == true ? .checkmark : .none //Ternary Operator
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK TableViewMethod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
         itemArray[indexPath.row].checkmark = !itemArray[indexPath.row].checkmark
        
       saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func ToDoAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add New ToDoEh Item", message: "Please type in below your new task you would like added to your list.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem = customDataModel()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
           self.saveItems()
        
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
            
           self.saveItems()
            
            
        }
        alert2.addAction(action2)
        present(alert2, animated: true, completion: nil)
        
        
    }
    
    func saveItems (){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!) //Writing data to a data file path
        }
            
        catch {
            print("error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data =  try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([customDataModel].self, from: data)
                
            }
            
            catch {
                print("error encoding item array, \(error)")
            }
        }
        
        
        
        
        
        
        
    }
    
}
