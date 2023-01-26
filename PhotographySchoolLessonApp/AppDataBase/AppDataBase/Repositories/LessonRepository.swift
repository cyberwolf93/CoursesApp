//
//  LessonRepository.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public class LessonRepository {
    
    private let controller: LessonDataController
    init(controller: LessonDataController) {
        self.controller = controller
    }
    
    //MARK: - Fetching data
    func getAll() -> [LessonModel] {
        var lessons = [LessonModel]()
        let lessonsDB = controller.getAll()
        lessonsDB.forEach { lessons.append(LessonModel.convertFrom(lessonDB: $0)) }
        return lessons
    }
    
    func get(with id: Int32) -> LessonModel? {
        guard let lessonDB = controller.get(with: id) else {
            return nil
        }
        
        return LessonModel.convertFrom(lessonDB: lessonDB)
    }
    
    //MARK: - Add data
    func add(lesson: LessonModel) {
        guard controller.get(with: lesson.id) == nil else {
            return
        }
        controller.add(lesson: lesson)
    }
    
    func add(lessons: [LessonModel]) {
        lessons.forEach{ self.add(lesson: $0) }
    }
    
    //MARK: - Delete Data
    func deleteAll() {
        controller.deleteAll()
    }
    
}
