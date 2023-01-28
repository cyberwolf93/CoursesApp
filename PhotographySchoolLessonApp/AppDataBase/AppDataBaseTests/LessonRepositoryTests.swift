//
//  AppDataBaseTests.swift
//  AppDataBaseTests
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import XCTest
@testable import AppDataBase
import AppModels

final class LessonRepositoryTests: XCTestCase {

    var appDatabase: AppDatabaseMock!
    var databaseStoreMock: DatabaseStoreMock!
    
    override func setUp() {
        super.setUp()
        appDatabase = AppDatabaseMock()
        databaseStoreMock = DatabaseStoreMock(appDatabaseManager: appDatabase.appDatabaseManager as! AppDatabaseManagerMock)
    }
    
    func testGetAllLessons() {
        let lessonsDB = databaseStoreMock.lessons
        databaseStoreMock.appDatabaseManager.saveContext()
        let lessons = appDatabase.lessonRepository.getAll()
        
        XCTAssertEqual(lessonsDB.count, lessons.count)
        XCTAssertEqual(lessonsDB.first!.id, lessons.first!.id)
        XCTAssertEqual(lessonsDB.first!.name, lessons.first!.name)
        XCTAssertEqual(lessonsDB.first!.lessonDescription, lessons.first!.lessonDescription)
        XCTAssertEqual(lessonsDB.first!.thumbnailUrl, lessons.first!.thumbnailUrl)
        XCTAssertEqual(lessonsDB.first!.videoUrl, lessons.first!.videoUrl)
        
    }
    
    func testGetWithIdAndLessonExist() {
        let lessonsDB = databaseStoreMock.lessons
        databaseStoreMock.appDatabaseManager.saveContext()
        let lesson = appDatabase.lessonRepository.get(with: lessonsDB.first!.id)
        
        self.continueAfterFailure = false
        
        XCTAssertNotNil(lesson)
        XCTAssertEqual(lessonsDB.first!.id, lesson!.id)
        XCTAssertEqual(lessonsDB.first!.name, lesson!.name)
        XCTAssertEqual(lessonsDB.first!.lessonDescription, lesson!.lessonDescription)
        XCTAssertEqual(lessonsDB.first!.thumbnailUrl, lesson!.thumbnailUrl)
        XCTAssertEqual(lessonsDB.first!.videoUrl, lesson!.videoUrl)
        
    }
    
    func testGetWithIdAndLessonDoesnotExist() {
        let lesson = appDatabase.lessonRepository.get(with: 12)
        XCTAssertNil(lesson)
    }
    
    func testAddLesson() {
        let lesson = LessonModel(id: 1,
                                 name: "test",
                                 lessonDescription: "test",
                                 thumbnailUrl: "test",
                                 videoUrl: "test")
        appDatabase.lessonRepository.add(lesson: lesson)
        
        let savedLessons =  try! appDatabase.appDatabaseManager.persistentContainer.viewContext.fetch(Lesson.fetchRequest())
        
        XCTAssertEqual(savedLessons.count, 1)
        XCTAssertEqual(savedLessons.first!.id, lesson.id)
        XCTAssertEqual(savedLessons.first!.name, lesson.name)
        XCTAssertEqual(savedLessons.first!.lessonDescription, lesson.lessonDescription)
        XCTAssertEqual(savedLessons.first!.thumbnailUrl, lesson.thumbnailUrl)
        XCTAssertEqual(savedLessons.first!.videoUrl, lesson.videoUrl)
        
    }
    
    func testAddLessonMoreThanOneLesson() {
        let lesson = LessonModel(id: 1,
                                 name: "test",
                                 lessonDescription: "test",
                                 thumbnailUrl: "test",
                                 videoUrl: "test")
        appDatabase.lessonRepository.add(lessons: [lesson])
        
        let savedLessons =  try! appDatabase.appDatabaseManager.persistentContainer.viewContext.fetch(Lesson.fetchRequest())
        
        XCTAssertEqual(savedLessons.count, 1)
        XCTAssertEqual(savedLessons.first!.id, lesson.id)
        XCTAssertEqual(savedLessons.first!.name, lesson.name)
        XCTAssertEqual(savedLessons.first!.lessonDescription, lesson.lessonDescription)
        XCTAssertEqual(savedLessons.first!.thumbnailUrl, lesson.thumbnailUrl)
        XCTAssertEqual(savedLessons.first!.videoUrl, lesson.videoUrl)
        
    }
    
    
    override func tearDown() {
        super.tearDown()
        appDatabase = nil
        databaseStoreMock = nil
    }
}
