//
//  Lesson+CoreDataClass.swift
//  
//
//  Created by Ahmed Mohiy on 26/01/2023.
//
//

import Foundation
import CoreData
import AppModels

public class Lesson: NSManagedObject {

}

//MARK: - Convert from CoreData lessonObject
extension Lesson {
    static func convertFrom(lessonDB: Lesson) -> LessonModel {
        return LessonModel(id: lessonDB.id,
                           name: lessonDB.name ?? "",
                           lessonDescription: lessonDB.lessonDescription ?? "",
                           thumbnailUrl: lessonDB.thumbnailUrl ?? "",
                           videoUrl: lessonDB.videoUrl ?? "")
    }
}
