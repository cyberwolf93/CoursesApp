//
//  LessonRemoteModel.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public struct LessonModel {
    let id: Int32
    let name: String
    let lessonDescription: String
    let thumbnailUrl: String
    let videoUrl: String
}

//MARK: - Convert from CoreData lessonObject
extension LessonModel {
    static func convertFrom(lessonDB: Lesson) -> LessonModel {
        return LessonModel(id: lessonDB.id,
                           name: lessonDB.name ?? "",
                           lessonDescription: lessonDB.lessonDescription ?? "",
                           thumbnailUrl: lessonDB.thumbnailUrl ?? "",
                           videoUrl: lessonDB.videoUrl ?? "")
    }
}
