//
//  CategoryViewController.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 24.07.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework 

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller is not exist.")}

        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        if let category = categories?[indexPath.row] {
                    guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
                    cell.backgroundColor = categoryColour
                    cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
                }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipularion Methods
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
      
        tableView.reloadData()
    }
    //MARK: - Delete Data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                }
                } catch {
                    print("Error deleting category, \(error)")
                }
        
            }
    }
    override func editModel(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            if textField.text != "" && textField.text != nil {
                if let category = self.categories?[indexPath.row] {
                    do {
                        try self.realm.write({
                            category.name = textField.text!
                            self.tableView.reloadData()
                        })
                    } catch {
                        print("Error eding category,\(error)")
                    }
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.text = self.categories?[indexPath.row].name
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Edit Data from swipe
    
    
            
    
        

    
    //MARK: - Add New Categories
    
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
        
            self.save(category: newCategory)
        }
        alert.addAction(action)
            
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
    
    }
    
}
//MARK: - Swipe Delegate Cell Methods

