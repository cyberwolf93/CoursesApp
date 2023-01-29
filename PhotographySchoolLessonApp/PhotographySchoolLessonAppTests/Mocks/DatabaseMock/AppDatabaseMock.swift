//
//  AppDatabaseMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//
@testable import AppDataBase
import AppModels
import Foundation

class AppDatabaseMock: AppDatabase {
    
    var lessonRepositoryMock: LessonRepositoryMock
    var downloadRepositoryMock: DownloadRepositoryMock
    
    override init() {
        let lessonController = LessonDataController(databaseManager: AppDatabaseManager.default)
        lessonRepositoryMock = LessonRepositoryMock(controller: lessonController)
        
        let downloadController = DownloadDataController(databaseManager: AppDatabaseManager.default)
        downloadRepositoryMock =  DownloadRepositoryMock(controller: downloadController)
        super.init()
    }
    
    override public var lessonRepository: LessonRepository {
        return lessonRepositoryMock
    }
    
    override public var downloadRepository: DownloadRepository {
        return downloadRepositoryMock
    }
    
}
