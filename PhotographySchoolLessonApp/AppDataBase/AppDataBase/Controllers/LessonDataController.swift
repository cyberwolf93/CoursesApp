//
//  LessonDataController.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation
import AppModels

class LessonDataController {
    
    let databaseManager: AppDatabaseManager
    
    init(databaseManager: AppDatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    //MARK: - Fetching data
    func getAll() -> [Lesson] {
        do {
            return try databaseManager.persistentContainer.viewContext.fetch(Lesson.fetchRequest())
        } catch {
            print("Failed to fetch all leassons error: \(error)")
            return []
        }
    }
    
    func get(with id: Int32) -> Lesson? {
        do {
            let fetchRequest = Lesson.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            return try databaseManager.persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch lesson: \(id) error: \(error)")
            return nil
        }
    }
    
    //MARK: - Add data
    func add(lesson: LessonModel) {
        let newLesson = Lesson(context: databaseManager.persistentContainer.viewContext)
        newLesson.id = lesson.id
        newLesson.name = lesson.name
        newLesson.lessonDescription = lesson.lessonDescription
        newLesson.thumbnailUrl = lesson.thumbnailUrl
        newLesson.videoUrl = lesson.videoUrl
        
        do {
            try databaseManager.persistentContainer.viewContext.save()
        } catch {
            print("Failed to add lesson \(lesson.id) error: \(error)")
        }
    }
    
    //MARK: - Delete Data
    func deleteAll() {
        do {
            try databaseManager.persistentContainer.viewContext.execute(Lesson.deleteRequest())
            try databaseManager.persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete all lessons error: \(error)")
        }
    }
}
