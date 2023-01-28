//
//  LessonRepository.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation
import AppModels

public class LessonRepository {
    
    private let controller: LessonDataController
    init(controller: LessonDataController) {
        self.controller = controller
    }
    
    //MARK: - Fetching data
    public func getAll() -> [LessonModel] {
        var lessons = [LessonModel]()
        let lessonsDB = controller.getAll()
        lessonsDB.forEach { lessons.append(Lesson.convertFrom(lessonDB: $0)) }
        return lessons
    }
    
    public func get(with id: Int32) -> LessonModel? {
        guard let lessonDB = controller.get(with: id) else {
            return nil
        }
        
        return Lesson.convertFrom(lessonDB: lessonDB)
    }
    
    //MARK: - Add data
    public func add(lesson: LessonModel) {
        guard controller.get(with: lesson.id) == nil else {
            return
        }
        controller.add(lesson: lesson)
    }
    
    public func add(lessons: [LessonModel]) {
        lessons.forEach{ self.add(lesson: $0) }
    }
    
    //MARK: - Delete Data
    public func deleteAll() {
        controller.deleteAll()
    }
    
}
