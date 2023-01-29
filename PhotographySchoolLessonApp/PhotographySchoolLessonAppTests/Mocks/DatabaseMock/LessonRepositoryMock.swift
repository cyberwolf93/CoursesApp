//
//  LessonRepositoryMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
@testable import AppDataBase
import AppModels
import XCTest

class LessonRepositoryMock: LessonRepository {
    
    var dataStore: DataStoreLesson = DataStoreLessonThreeItems()
    
    var addExpectation: XCTestExpectation?
    
    override func getAll() -> [LessonModel] {
        return dataStore.lessons
    }
    
    override func add(lessons: [LessonModel]) {
        addExpectation!.fulfill()
    }
    
}
