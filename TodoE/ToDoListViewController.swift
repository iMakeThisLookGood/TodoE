//
//  ViewController.swift
//  TodoE
//
//  Created by Jon Kyer on 5/23/19.
//  Copyright © 2019 Jon Kyer. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find It", "Destroy Stuff", "Eat"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
            itemArray=items
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //Enabling the checkmark when pressed and removing if alreadu on
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        

        
        //Deselect the row so it doesnt show the gray the whole time
            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField =  UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What will happen once the user pressed the add button after adding text
            self.itemArray.append(textField.text!)
            
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

