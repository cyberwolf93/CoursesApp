//
//  Lesson+CoreDataProperties.swift
//  
//
//  Created by Ahmed Mohiy on 26/01/2023.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }
    
    @nonobjc public class func deleteRequest() -> NSBatchDeleteRequest {
        return NSBatchDeleteRequest(fetchRequest: Self.fetchRequest())
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var lessonDescription: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var videoUrl: String?

}
