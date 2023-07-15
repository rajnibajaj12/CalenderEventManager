//
//  EventDataModel+CoreDataProperties.swift
//  
//
//  Created by Rajni Bajaj on 13/07/23.
//
//

import Foundation
import CoreData


extension EventDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventDataModel> {
        return NSFetchRequest<EventDataModel>(entityName: "EventDataModel")
    }

    @NSManaged public var eventName: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventDate: String?
    @NSManaged public var eventCategory: String?
    @NSManaged public var eventColor: String?
    @NSManaged public var eventLocation: String?
    @NSManaged public var eventID: String?
    @NSManaged public var categoryID: String?
    @NSManaged public var isReminder: Bool?
    @NSManaged public var reminderTime: String?
    @NSManaged public var eventCatIcon: Data?

}
