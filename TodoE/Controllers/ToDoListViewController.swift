//
//  ViewController.swift
//  TodoE
//
//  Created by Jon Kyer on 5/23/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        

        let newItem = Item()
        newItem.title = " Find Something"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = " Buy Stuff"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Eat"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }

        
        
        
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
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
        
        //Checkmark completion property
        //if true, then it becomes false and vice versa
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        
        //Enabling the checkmark when pressed and removing if alreadu on
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        

        //Reloading the data
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
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
              //Adding saving functionality
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //Reloading the table to add the new text
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
    
    
    
}
