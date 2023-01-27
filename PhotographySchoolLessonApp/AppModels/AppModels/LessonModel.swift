//
//  LessonRemoteModel.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public struct LessonModel: Hashable {
    public let id: Int32
    public let name: String
    public let lessonDescription: String
    public let thumbnailUrl: String
    public let videoUrl: String
    
    public init(id: Int32, name: String, lessonDescription: String, thumbnailUrl: String, videoUrl: String) {
        self.id = id
        self.name = name
        self.lessonDescription = lessonDescription
        self.thumbnailUrl = thumbnailUrl
        self.videoUrl = videoUrl
    }
}


