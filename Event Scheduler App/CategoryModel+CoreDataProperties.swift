//
//  CategoryModel+CoreDataProperties.swift
//  
//
//  Created by Rajni Bajaj on 13/07/23.
//
//

import Foundation
import CoreData


extension CategoryModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryModel> {
        return NSFetchRequest<CategoryModel>(entityName: "CategoryModel")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var categoryID: String?
    @NSManaged public var categoryColor: String?
    @NSManaged public var categoryIcon:Data?

}
