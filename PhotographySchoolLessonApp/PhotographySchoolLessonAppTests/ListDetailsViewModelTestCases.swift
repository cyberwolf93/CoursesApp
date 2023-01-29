//
//  ListDetailsViewModelTestCases.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import XCTest
import AppModels
import Combine
@testable import PhotographySchoolLessonApp

class ListDetailsViewModelTestCases: XCTestCase {
    var appDatabase: AppDatabaseMock!
    var downloadService: DownloadServiceMock!
    var fileManager: FileManagerMock!
    var downloadManager: DownloadManager!
    var cancelable =  Set<AnyCancellable>()
    
    override func setUp() {
        appDatabase = AppDatabaseMock()
        downloadService = DownloadServiceMock()
        fileManager = FileManagerMock()
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
    }
    
    func testGetNextLesson() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
    
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        let expectedLesson = viewModel.getNextLesson()
        XCTAssertEqual(expectedLesson!.id, nextLessons.last!.id)
    }
    
    func testPrepareNextLessonList() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
    
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        let expectedNextList = viewModel.prepareNextLessonList()
        XCTAssertEqual(expectedNextList.count, 2)
        XCTAssertEqual(expectedNextList.first!.id, nextLessons.first!.id)
        XCTAssertEqual(expectedNextList[1].id, nextLessons[1].id)
    }
    
    func testListenForDownloadComplete() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let expectation = XCTestExpectation(description: "expectation")
    
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
        viewModel.downloadCompleteSubject
            .sink { _ in
                expectation.fulfill()
            }.store(in: &cancelable)
        
        downloadManager.downloadCompleteSubject.send(nextLessons.first!.id)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(true)
    }
    
    func testListenForDownloadProgressUpdate() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let expectation = XCTestExpectation(description: "expectation")
        let progress:Float = 0.5
        var progressUpdate: Float = 0
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
        viewModel.downloadProgressSubject
            .sink { progress in
                progressUpdate = progress
                expectation.fulfill()
            }.store(in: &cancelable)
        
        downloadManager.downloadProgressSubject.send((id: nextLessons.first!.id, progress: progress))
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(progress, progressUpdate)
    }
    
    func testCheckLessonInDownloadQueue() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: "")
        
        let viewModel = ListDetailsViewModel(lesson: lesson,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
      
        let result = viewModel.checkLessonInDownloadQueue()
        
        XCTAssertTrue(result)
    }
    
    func testCheckLessonNotInDownloadQueue() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let lesson = LessonModel(id: 0,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: "")
        
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        
        let viewModel = ListDetailsViewModel(lesson: lesson,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
      
        let result = viewModel.checkLessonInDownloadQueue()
        
        XCTAssertFalse(result)
    }
    
    func testCheckLessonDownloadComplete() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: "")
        
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        
        let viewModel = ListDetailsViewModel(lesson: lesson,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
      
        let result = viewModel.checkLessonDownloadComplete()
        
        XCTAssertTrue(result)
    }
    
    func testCheckLessonDownloadNotComplete() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        
        downloadRepository.dataStore = DataStoreDownloadOneItemDownloadNotComplete()
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: "")
        
        downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        
        let viewModel = ListDetailsViewModel(lesson: lesson,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManager)
        
      
        let result = viewModel.checkLessonDownloadComplete()
        
        XCTAssertFalse(result)
    }
    
    
    func testStartDownload() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let expectation = XCTestExpectation(description: "expectation")
        let downloadManagerMock = DownloadManagerMock()
        downloadManagerMock.startExpectation = expectation
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManagerMock)
        
        
        
        viewModel.startDownload()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(downloadManagerMock.downloadStarted)
        
    }
    
    func testStartDownloadCanceld() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        let nextLessons = lessonRepository.dataStore.lessons
        
        let expectation = XCTestExpectation(description: "expectation")
        let downloadManagerMock = DownloadManagerMock()
        downloadManagerMock.cancelExpectation = expectation
        
        let viewModel = ListDetailsViewModel(lesson: nextLessons.first!,
                                             nextLessons: nextLessons,
                                             downloadManager: downloadManagerMock)
        
        
        
        viewModel.removeDownload()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(downloadManagerMock.downloadCanceled)
        
    }
    
    
    override func tearDown() {
        appDatabase = nil
        downloadService = nil
        fileManager = nil
        downloadManager = nil
    }
}
