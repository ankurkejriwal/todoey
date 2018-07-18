//
//  ViewController.swift
//  todoey
//
//  Created by Ankur Kejriwal on 2018-06-14.
//  Copyright © 2018 Ankur kejriwal. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    var selectedCatergory : Catergory? {
        didSet{
            loadItems()
        }
    }
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
       // print (dataFilePath)
      
        
        
        
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) // Populating the current index path
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let itemz = itemArray[indexPath.row]

        cell.accessoryType = itemz.done == true ? .checkmark : .none //Ternary Operator
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK TableViewMethod
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func ToDoAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController.init(title: "Add New ToDoEh Item", message: "Please type in below your new task you would like added to your list.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            newItem.parentCatergory = self.selectedCatergory
            
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
            self.deleteAll()
            self.saveItems()
            
            
        }
        alert2.addAction(action2)
        present(alert2, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Data Handeling Methods
    func saveItems (){
        
        
        do {
          try context.save()
        }
            
        catch {
            
            print("error saving the context \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        
        let CatergoryPredicate = NSPredicate(format: "parentCatergory.name MATCHES %@",selectedCatergory!.name!)
        
        if let additonalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [CatergoryPredicate,additonalPredicate])
        }
        else{
            request.predicate = CatergoryPredicate
        }
        
        
      
        do{
            itemArray = try context.fetch(request)
        }
        
        catch{
        
            print("error fetching data from context \(error)")
            
        }
        
        tableView.reloadData()
        }
    
    func deleteAll(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteRequest)
            
        }
        catch{
            print("error while deleting data from context \(error)")

        
        }
    
      loadItems()
        
       }
    
}
// MARK:- Search Bar Method
extension ToDoListViewController{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        var predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
    

