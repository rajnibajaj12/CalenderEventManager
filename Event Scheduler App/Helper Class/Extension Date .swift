//
//  Extension Date .swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 12/07/23.
//

import Foundation

extension Date {
    
    func dateString(_ format: String = "yyyy/MM/dd, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
      
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func changeDateString(_ format: String = "yyyy/MM/dd hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
     
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
}
