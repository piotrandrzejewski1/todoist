//
//  CategoriesTableViewController.swift
//  todoist
//
//  Created by Piotr Andrzejewski on 19/12/2018.
//  Copyright © 2018 Piotr Andrzejewski. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    var categoriesArray = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }

    //MARK: - tableview handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsVc = segue.destination as! ItemsTableViewController
            itemsVc.selectedCategory = categoriesArray[tableView.indexPathForSelectedRow!.row]
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
            
            let category = Category(context: self.context)
            category.name = alertTextField!.text!
            self.saveData()
            self.categoriesArray.append(category)
            self.tableView.reloadData()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - data manipulation
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoriesArray = try context.fetch(request)
        }
        catch {
            print("\(error)")
        }
    }
    
    func saveData() {
        do {
            try context.save()
        }
        catch {
            print("\(error)")
        }
    }
}
