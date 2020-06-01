//
//  ToDoListVC.swift
//  autoLayouts
//
//  Created by karan on 09/04/19.
//  Copyright © 2019 karan. All rights reserved.
//

import UIKit

protocol ToDoListDelegate: class {
    
    func update()
        
}

//karan

class ToDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblVw: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var toDoItems: [ToDoItem] {
        
//        do {
//
//            return try context.fetch(ToDoItem.fetchRequest())
//
//        }
//        catch {
//
//            print("Couldn't fetch data")
//
//        }
        
        return [ToDoItem]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblVw.delegate = self
        
        tblVw.dataSource = self
        
        tblVw.tableFooterView = UIView()
        
        title = "To Do List"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
//        let testItem = ToDoItem(name: "Test Item1", details: "Test Details1", completionDate: Date())
//
//        self.toDoItems.append(testItem)
//
//        let testItem2 = ToDoItem(name: "Test Item2", details: "Test Details2", completionDate: Date())
//
//        self.toDoItems.append(testItem2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        tblVw.setEditing(false, animated: false)
        
    }
    
    @objc func addNewTask(_ notification: NSNotification) {
        /*
        var toDoItem: ToDoItem!
        
        if let task = notification.object as? ToDoItem {
            
            toDoItem = task
            
        }
        else if let taskDict = notification.userInfo as NSDictionary? {
            
            guard let task = taskDict["Task"] as? ToDoItem else { return }
            
            toDoItem = task
            
        }
            
        else {
            
            return
            
        }
        
        toDoItems.append(toDoItem)
        
        toDoItems.sort(by: { $0.completionDate > $1.completionDate })
        */
        tblVw.reloadData()
        
    }
    
    @objc func addTapped(){
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
        
    }
    
    @objc func editTapped(){
        
        tblVw.setEditing(!tblVw.isEditing, animated: true)
        
        if tblVw.isEditing == true {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            
        }
        else{
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = toDoItems[indexPath.row]
        
        let cell = tblVw.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItems = toDoItems[indexPath.row]
        
        let toDoTuple = (indexPath.row, selectedItems)
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let toDoItem = self.toDoItems[indexPath.row]
            
//            self.context.delete(toDoItem)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
//            self.toDoItems.remove(at: indexPath.row)
            
            self.tblVw.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
        
        return [delete]
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "TaskDetailsSegue" {
            
            guard let destinationVC = segue.destination as? ToDoDetailVC else { return }
            
            guard let toDoTuple = sender as? (Int, ToDoItem) else { return }
            
            print("toDoItem : \(toDoTuple.1)")
            
            print("indexxx : \(toDoTuple.0)")
            
            destinationVC.toDoIndex = toDoTuple.0
            
            destinationVC.toDoItem = toDoTuple.1
            
            destinationVC.delegate = self
            
        }
        else if segue.identifier == "AddTaskSegue" {
            
            guard let destinationVC = segue.destination as? AddTaskVC else { return }
            
            destinationVC.delegate = self
            
        }

    }
 
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
        
    }
    
}

extension ToDoListVC: ToDoListDelegate {
    
    func update() {
        
//        toDoItems[index] = task
        
        tblVw.reloadData()
        
    }
    
}
