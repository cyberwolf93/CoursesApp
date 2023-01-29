//
//  LessonRepositoryMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
@testable import AppDataBase
import AppModels

class LessonRepositoryMock: LessonRepository {
    
    var dataStore: DataStoreLesson = DataStoreLessonThreeItems()
    
}
