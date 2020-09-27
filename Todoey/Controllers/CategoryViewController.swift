//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 김정태 on 2020/07/05.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import RealmSwift
import UIKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar is not exist!")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category yet"
        
        let colorHexCode = categories?[indexPath.row].color ?? "#ffffff"
        
        if let backgroundColor = UIColor(hexString: colorHexCode) {
            
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            
        }
        
        return cell
    }
    
    // MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manupulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete Date Method
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        do {
            try realm.write {
                if let deleteItem = self.categories?[indexPath.row] {
                    self.realm.delete(deleteItem)
                }
            }
        } catch {
            print("Error delete category, \(error)")
        }
    }
    
    // MARK: - TableView Datasource Methods
}
