//
//  Lesson.swift
//  ClientAPI
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels

struct LessonsResponse: Decodable {
    let lessons: [LessonResponse]
}

struct LessonResponse: Decodable {
    let id: Int32
    let name: String
    let lessonDescription: String
    let thumbnailUrl: String
    let videoUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lessonDescription = "description"
        case thumbnailUrl = "thumbnail"
        case videoUrl = "video_url"
    }
}

extension LessonResponse {
    func convertTo() -> LessonModel {
        return LessonModel(id: self.id,
                           name: self.name,
                           lessonDescription: self.lessonDescription,
                           thumbnailUrl: self.thumbnailUrl,
                           videoUrl: self.videoUrl)
    }
}
