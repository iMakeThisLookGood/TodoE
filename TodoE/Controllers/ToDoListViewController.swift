//
//  ViewController.swift
//  TodoE
//
//  Created by Jon Kyer on 5/23/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
        
    }
    
    
    //Converting our save data to a more reliable sourse
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
    }
    
    //MARK - Tableview DataSource Methods
    //How many rows to return
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

//Where to insert the data and to reuse cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        


        cell.textLabel?.text = item.title
        
        //Ternary opertor usage
        // value = condition ? valueIfTrue : valueIfFalse
        //Set the cell . ACCytype if item.done check mark is true :: or none if false
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
       
        //Deleting the item from the array with Core Data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        
        //Checkmark completion property
        //if true, then it becomes false and vice versa
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //Deselect the row so it doesnt show the gray the whole time
            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user pressed the add button after adding text
//            self.itemArray.append(textField.text!)
        
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
          
        }
        
        //Adding the text field to the alert!
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
                textField = alertTextField
            
        }
            alert.addAction(action)
        
            present(alert, animated: true, completion: nil)
    
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems(){
        
        
        do {
          try  context.save()
            
        } catch {
            print("Error Saving Context, \(error)")
        }
        
        //Reloading the table to add the new text
        self.tableView.reloadData()

        
    }
    
    //Creating a function that expects soemthing from Items Array
    //But defaults to the do catch if there is nothing passed with a parameter
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
      
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
            
        }

        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
                tableView.reloadData()
    }
}

//MARK: - Extension for SearchBarDelegate and Methods


//Spliting up the delegate for ease of use using an extension
extension ToDoListViewController:UISearchBarDelegate{
    //Reload Table data when searching for items
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Looking in the database
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        //Filtering the data using OBJC Predicate by trying to find the data with data that contains the same words
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //Sorting the data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //fetching the result
        loadItems(with: request, predicate: predicate)
        
    }
    
    //Delegate method to change the results if the user deletes the search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            //Stops the search bar from being selected any further
            //Runs the method on the main thread with the dispatch
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
        
    }
    
    
}

