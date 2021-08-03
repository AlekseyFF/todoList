//
//  SwipeTableViewController.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 31.07.2021.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0

    }
    
    //Table view Datasource Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                    
                    self.updateModel(at: indexPath)
                    
                }
                
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            
            self.editModel(at: indexPath)
        }
        editAction.transitionDelegate = ScaleTransition.default
        
                // customize the action appearance
                deleteAction.image = UIImage(named: "trash-image")
                editAction.image = UIImage(named: "edit-image")
           
        
            
        

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-image")
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updateModel(at indexPath: IndexPath) {
        
    }
    func editModel(at indexPath: IndexPath) {
        
    }

}
        

//MARK: - Edit




