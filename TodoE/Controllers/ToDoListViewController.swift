//
//  ViewController.swift
//  TodoE
//
//  Created by Jon Kyer on 5/23/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
        
    }
    
    
    //Converting our save data to a more reliable sourse
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
    }
    
    //MARK - Tableview DataSource Methods
    //How many rows to return
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

//Where to insert the data and to reuse cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        


        cell.textLabel?.text = item.title
        
        //Ternary opertor usage
        // value = condition ? valueIfTrue : valueIfFalse
        //Set the cell . ACCytype if item.done check mark is true :: or none if false
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row]{
        do {
            try realm.write {

                item.done = !item.done
            }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
            tableView.reloadData()
        
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
        
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
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
    func loadItems() {

        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
    }
}

//MARK: - Extension for SearchBarDelegate and Methods


//Spliting up the delegate for ease of use using an extension
extension ToDoListViewController:UISearchBarDelegate{
    //Reload Table data when searching for items
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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


