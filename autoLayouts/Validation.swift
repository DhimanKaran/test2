//
//  Validation.swift
//  autoLayouts
//
//  Created by karan on 14/04/19.
//  Copyright © 2019 karan. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    
    case Empty
    
    case Short
    
    case Long
    
}

//karan

class Validation {
    
    func validateText(text: String?, minLength: Int, maxLength: Int) throws -> String {
        
        guard let text = text, !text.isEmpty else {
            
            throw ValidationError.Empty
            
        }
        
        if text.count < minLength {
            
            throw ValidationError.Short
            
        }
        
        if text.count > maxLength {
            
            throw ValidationError.Long
            
        }
        
        return text
        
    }
    
}
