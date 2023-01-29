//
//  DownloadManagerMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

@testable import PhotographySchoolLessonApp
import XCTest
import AppDataBase
import AppModels
import Foundation

class DownloadManagerMock : DownloadManager {
    
    var startExpectation: XCTestExpectation!
    var cancelExpectation: XCTestExpectation!
    var downloadStarted = false
    var downloadCanceled = false
    
    override init(databaseController: AppDatabase = AppDatabaseMock(), downloadService: DownloadService = DownloadServiceMock(), fileManager: FileManager = FileManagerMock()) {
        super.init(databaseController: databaseController, downloadService: downloadService, fileManager: fileManager)
    }
    
    override func download(lesson: LessonModel) {
        downloadStarted = true
        startExpectation.fulfill()
    }
    
    override func cancelDownloadFor(id: Int32) {
        downloadCanceled = true
        cancelExpectation.fulfill()
    }
    
}
