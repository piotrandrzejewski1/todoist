//
//  CategoriesTableViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 19/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {

    let realm = try! Realm()
    var categoriesArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }

    //MARK: - tableview handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray![indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsVc = segue.destination as! ItemsTableViewController
            itemsVc.selectedCategory = categoriesArray?[tableView.indexPathForSelectedRow!.row]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    //MARK: - add new item
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        var alertTextField : UITextField?
        alert.addTextField { (textField) in
            alertTextField = textField
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if alertTextField!.text == "" {
                return
            }
            
            do {
                try self.realm.write {
                    let category = Category()
                    category.name = alertTextField!.text!
                    self.realm.add(category)
                }
            }
            catch {
                print("\(error)")
            }
            
            self.tableView.reloadData()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
}
