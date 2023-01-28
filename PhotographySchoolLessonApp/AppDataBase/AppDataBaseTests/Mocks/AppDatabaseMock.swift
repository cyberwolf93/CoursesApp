//
//  AppDatabaseMock.swift
//  AppDataBaseTests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import AppDataBase
import Foundation

class AppDatabaseMock: AppDatabase {
    
    var appDatabaseManager: AppDatabaseManager
    
    override init() {
        appDatabaseManager = AppDatabaseManagerMock()
        super.init()
    }
    
    override public var lessonRepository: LessonRepository {
        let lessonController = LessonDataController(databaseManager:appDatabaseManager)
        return LessonRepository(controller: lessonController)
    }
    
    override public var downloadRepository: DownloadRepository {
        let downloadController = DownloadDataController(databaseManager:appDatabaseManager)
        return DownloadRepository(controller: downloadController)
    }
    
}
