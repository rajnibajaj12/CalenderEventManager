//
//  CustomerConstant.swift
//  Event Scheduler App
//
//  Created by Rajni Bajaj on 13/07/23.
//

import Foundation

class CustomerConstant {
    class func getCurrentDateString(withFormat:String,withDate:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = withFormat
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        let newDate = dateformatter.string(from: withDate)
        return newDate
    }
}
