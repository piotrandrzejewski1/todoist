//
//  ViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 18/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {

    var itemsArray = ["Kup zupę", "Zrób kupę", "Kup kupę"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - table view handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }
        else {
            cell?.accessoryType = .checkmark
        }
    }
    
    
    //MARK: - adding new item
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var alertTextField : UITextField? = nil
        let alert = UIAlertController(title: "Add new list", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            alertTextField = textField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if alertTextField?.text != "" {
                self.itemsArray.append(alertTextField!.text!)
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

