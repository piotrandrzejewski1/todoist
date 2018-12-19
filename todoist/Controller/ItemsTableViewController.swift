//
//  ViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 18/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController, UISearchBarDelegate {

    var itemsArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }

    //MARK: - table view handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
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
                let item = Item(context: self.context)
                item.name = alertTextField!.text!
                item.done = false
                
                self.itemsArray.append(item)
                self.saveData()
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - managing data
    func saveData() {
        do {
            try context.save()
        }
        catch {
            print("\(error)")
        }
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemsArray = try context.fetch(request)
        }
        catch {
            print("\(error)")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadData(with : request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadData()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

