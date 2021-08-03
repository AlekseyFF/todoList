//
//  ViewController.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 16.07.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.separatorStyle = .none
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        
        if let colourHex = selectedCategory?.colour {
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller is not exist.")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
            navBar.backgroundColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
            searchBar.backgroundColor = navBarColour
            }
        }
    }

    //MARK: - Datasource Methods (Tableview)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
       }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
                                                
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
      
        return cell
     }
    //MARK: - Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write({
                item.done = !item.done
            })
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - add button (new items)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clics the Add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)

                })
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
            
            }
            
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
    
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
            }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    override func editModel(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            if textField.text != "" && textField.text != nil {
                if let items = self.todoItems?[indexPath.row] {
                    do {
                        try self.realm.write({
                            items.title = textField.text!
                            self.tableView.reloadData()
                        })
                    } catch {
                        print("Error eding category,\(error)")
                    }
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.text = self.todoItems?[indexPath.row].title
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

