//
//  ViewController.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-06-14.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    let realm = try! Realm()
    var todoitems : Results<Item>?

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    var selectedCatergory : catergory? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // print (dataFilePath)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Populating the current index path
        
        if let item = todoitems?[indexPath.row]{
            cell.textLabel?.text = todoitems?[indexPath.row].title
            cell.accessoryType = item.done ? .checkmark : .none //Ternary Operator
            
            }
        
        else{
            cell.textLabel?.text = "No Items added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoitems?.count ?? 1
    }
    
    //MARK TableViewMethod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoitems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
            }
            }
            
            catch {
                print ("Error saving done status\(error)")
            }
        }

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func ToDoAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add New ToDoEh Item", message: "Please type in below your new task you would like added to your list.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCatergory = self.selectedCatergory{
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCatergory.items.append(newItem)
                }
                }
                catch {
                    print ("Error saving new items\(error)")
                }
            
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new Item"
            
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Handeling Methods

    
    func loadItems(){
        
       todoitems = selectedCatergory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        }
    
    
    
}
// MARK:- Search Bar Method
extension ToDoListViewController{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoitems = todoitems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
        tableView.reloadData()
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            loadItems() // Fetches all of the items from persistent container
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()// No long have cursor and keyboard should disappear
            }
            
            
        }
        
    }
        
    
        
    
    }


