//
//  ToDoModel.swift
//  autoLayouts
//
//  Created by karan on 09/04/19.
//  Copyright © 2019 karan. All rights reserved.
//

import Foundation

struct ToDoItem {
    
    var name: String
    
    var details: String
    
    var completionDate: Date
    
    var startDate: Date
    
    var isComplete: Bool
    
    init(name: String, details: String, completionDate: Date) {
        
        self.name = name
        
        self.details = details
        
        self.completionDate = completionDate
        
        self.startDate = Date()
        
        self.isComplete = false
        
    }
    
}

