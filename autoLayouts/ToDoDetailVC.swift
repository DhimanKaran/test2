//
//  ToDoDetailVC.swift
//  autoLayouts
//
//  Created by karan on 09/04/19.
//  Copyright © 2019 karan. All rights reserved.
//

import UIKit

class ToDoDetailVC: UIViewController {

    @IBOutlet weak var taskTitleLbl: UILabel!
    
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    @IBOutlet weak var taskDetailsTxtVw: UITextView!
    
    @IBOutlet weak var taskCompletionBtn: UIButton!
    
    var toDoItem: ToDoItem!
    
    var toDoIndex: Int!
    
    weak var delegate: ToDoListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello world")
        
        taskTitleLbl.text = toDoItem.name
        
        taskDetailsTxtVw.text = toDoItem.details
        
        if toDoItem.isComplete{
            
            disableButton()
            
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        
        let taskDate = formatter.string(from: toDoItem.completionDate!)
        
        taskCompletionDate.text = taskDate

    }
    
    func disableButton() {
        
        taskCompletionBtn.backgroundColor = UIColor.gray
        
        taskCompletionBtn.isEnabled = true
        
    }

    @IBAction func taskDidComplete(_ sender: Any) {
        
        toDoItem.isComplete = true
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        delegate?.update()
        
        disableButton()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
