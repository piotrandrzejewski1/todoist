//
//  ViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 18/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsTableViewController: UITableViewController {

    var selectedCategory : Category? {
        didSet {
            items = selectedCategory!.items.sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }
    }
    
    var realm = try! Realm()
    var items : Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - table view handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = items![indexPath.row].name
        cell.accessoryType = items![indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            try realm.write {
                items![indexPath.row].done = !items![indexPath.row].done
            }
        }
        catch {
            print("\(error)")
        }
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

                do {
                    let item = Item()
                    item.name = alertTextField!.text!
                    item.done = false
                    item.date = Date()
                    try self.realm.write {
                        self.selectedCategory!.items.append(item)
                    }
                }
                catch {
                    print("\(error)")
                }

                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ItemsTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        items = selectedCategory!.items.filter(predicate).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            items = selectedCategory!.items.sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

