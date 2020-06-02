//
//  AddTaskVC.swift
//  autoLayouts
//
//  Created by karan on 09/04/19.
//  Copyright © 2019 karan. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var taskNameTxtField: UITextField!
    
    @IBOutlet weak var taskDetailsTxtVw: UITextView!
    
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    
    @IBOutlet weak var addTaskBtn: UIButton!
    
    @IBOutlet weak var scrollVw: UIScrollView!
        
    lazy var touchView: UIView = {
        
       let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
        
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.addGestureRecognizer(touchViewTapped)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        return _touchView
        
    }()
    
    var message: String = "message"
    
    let toolBarDone = UIToolbar.init()
    
    var activeTxtField: UITextField?
    
    var activeTxtView: UITextView?
    
    weak var delegate: ToDoListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationItem = UINavigationItem(title: "Add Task")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTouch))
        
        navigationBar.items = [navigationItem]
        
        taskDetailsTxtVw.layer.borderColor = UIColor.lightGray.cgColor
        
        taskDetailsTxtVw.layer.borderWidth = CGFloat(1)
        
        taskDetailsTxtVw.layer.cornerRadius = CGFloat(3)
        
        toolBarDone.sizeToFit()
        
        toolBarDone.barTintColor = UIColor.red
        
        toolBarDone.isTranslucent = false
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let barButtonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        toolBarDone.items = [flexSpace, barButtonDone, flexSpace]
        
        taskNameTxtField.inputAccessoryView = toolBarDone
        
        taskDetailsTxtVw.inputAccessoryView = toolBarDone
        
        taskNameTxtField.delegate = self
        
        taskDetailsTxtVw.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        registerForKeyboardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                
        deregisterForKeyboardNotification()
    
    }
    
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        
    }
    
    func deregisterForKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        view.addSubview(touchView)
                
        let info: NSDictionary = notification.userInfo! as NSDictionary
        
        let keyBoardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyBoardSize!.height + toolBarDone.frame.size.height + 10.0), right: 0.0)
        
        self.scrollVw.contentInset = contentInsets
        
        self.scrollVw.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = UIScreen.main.bounds
        
        aRect.size.height -= keyBoardSize!.height
        
        if activeTxtField != nil {
            
            if (!aRect.contains(activeTxtField!.frame.origin)) {
                
                self.scrollVw.scrollRectToVisible(activeTxtField!.frame, animated: true)
                
            }
            
        }
        
        else if activeTxtView != nil {
            
            let textViewPoint: CGPoint = CGPoint(x: activeTxtView!.frame.origin.x, y: activeTxtView!.frame.size.height + activeTxtView!.frame.size.height)
            
            if (aRect.contains(textViewPoint)) {
                
                self.scrollVw.scrollRectToVisible(activeTxtView!.frame, animated: true)
                
            }
            
        }
        
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        
        touchView.removeFromSuperview()
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        self.scrollVw.contentInset = contentInsets
        
        self.scrollVw.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
        
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
    @objc func doneButtonTapped() {
        
        view.endEditing(true)
        
    }
    
    @objc func cancelButtonDidTouch() {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        let validation = Validation()
        
        //let task = try? validation.validateText(text: taskNameTxtField.text, minLength: 4, maxLength: 10)
        
        var taskName: String = ""
        
        do{
            
            taskName = try validation.validateText(text: taskNameTxtField.text, minLength: 4, maxLength: 10)
            
        }
        catch ValidationError.Empty {
            
            reportError(title: "Task name empty", message: "Task name field is required")
            
            return
            
        }
        catch ValidationError.Short {
            
            reportError(title: "Task name short", message: "Please enter a task name that is between 4 and 10 characters long")
            
            return
            
        }
        catch ValidationError.Long {
            
            reportError(title: "Task name to long", message: "Please enter a task name that is between 4 and 10 characters long")
            
            return
            
        }
        catch {
            
            reportError(title: "Task name invalid", message: "Please check the task name you have entered")
            
            return
            
        }
        
        var taskDetail: String = ""
        
        do {
            
            taskDetail = try validation.validateText(text: taskDetailsTxtVw.text, minLength: 8, maxLength: 20)
            
        }
        catch ValidationError.Empty {
            
            reportError(title: "Task detail empty", message: "Task detail field is required")
            
            return
            
        }
        catch ValidationError.Short {
            
            reportError(title: "Task detail short", message: "Please enter a task name that is between 8 and 20 characters long")
            
            return
            
        }
        catch ValidationError.Long {
            
            reportError(title: "Task name to long", message: "Please enter a task name that is between 8 and 20 characters long")
            
        }
        catch {
            
            reportError(title: "Task detail invalid", message: "Please check the task detail you have entered")
            
        }
        
        let taskDetails: String = taskDetailsTxtVw.text
        
        let completionDate: Date = taskCompletionDatePicker.date
        
        if completionDate < Date() {
            
            reportError(title: "Invalid Date", message: "Date must be in future")
            
            return
            
        }
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let toDoItem = ToDoItem(context: context)
//
//        toDoItem.name = taskName
//
//        toDoItem.details = taskDetails
//
//        toDoItem.completionDate = completionDate
//
//        toDoItem.isComplete = false
//
//        toDoItem.startDate = Date()
//
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //let toDoItem = ToDoItem(name: taskName, details: taskDetails, completionDate: completionDate)
        
//        delegate?.update()
        
//        let toDoDict: [String: ToDoItem] = ["Task": toDoItem]
        
//        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: toDoItem)
        
//        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil, userInfo: toDoDict)
        
        dismiss(animated: true, completion: nil)
        
    }

    func reportError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(okAction)
        
        present(alert,animated: true,completion: nil)
        
    }
    
}

extension AddTaskVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTxtField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeTxtField = nil
        
    }
    
}

extension AddTaskVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        activeTxtView = textView
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        activeTxtView = nil
        
    }
    
}
