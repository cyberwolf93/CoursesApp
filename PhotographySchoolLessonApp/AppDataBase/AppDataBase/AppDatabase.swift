//
//  AppDatabase.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation

public class AppDatabase {
    
    public static let `default`: AppDatabase = AppDatabase()
    
    public var lessonRepository: LessonRepository {
        let lessonController = LessonDataController(databaseManager: AppDatabaseManager.default)
        return LessonRepository(controller: lessonController)
    }
    
    public var downloadRepository: DownloadRepository {
        let downloadController = DownloadDataController(databaseManager: AppDatabaseManager.default)
        return DownloadRepository(controller: downloadController)
    }
}
