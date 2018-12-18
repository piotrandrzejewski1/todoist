//
//  ViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 18/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {

    var itemsArray = [ListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }

    //MARK: - table view handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].name
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        saveData()
        tableView.reloadData()
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
                self.itemsArray.append(ListItem(name : alertTextField!.text!))
                self.saveData()
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - managing data
    var itemsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("items.plist");
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: itemsDirectory)
        }
        catch {
        }
    }
    
    func loadData() {
        
        if let data = try? Data(contentsOf: itemsDirectory) {
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([ListItem].self, from: data)
            }
            catch {
                print("\(error)")
            }
        }
    }
}

