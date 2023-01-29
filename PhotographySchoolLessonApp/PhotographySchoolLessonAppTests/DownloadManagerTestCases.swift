//
//  PhotographySchoolLessonAppTests.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import XCTest
import AppModels
import Combine
@testable import PhotographySchoolLessonApp

final class DownloadManagerTestCases: XCTestCase {

    var appDatabase: AppDatabaseMock!
    var downloadService: DownloadServiceMock!
    var fileManager: FileManagerMock!
    var cancelable =  Set<AnyCancellable>()
    
    override func setUp() {
        appDatabase = AppDatabaseMock()
        downloadService = DownloadServiceMock()
        fileManager = FileManagerMock()
    }
    
    func testDownloadExpectStart() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        let downloadServiceExpectation = XCTestExpectation(description: "downloadServiceExpectation")
        
        
        (appDatabase.downloadRepository as! DownloadRepositoryMock).expectation = appDatabaseExpectation
        downloadService.startExepectation = downloadServiceExpectation
        
        let lesson = LessonModel(id: 1, name: "", lessonDescription: "", thumbnailUrl: "", videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.download(lesson: lesson)
        
        wait(for: [appDatabaseExpectation,downloadServiceExpectation], timeout: 2)
        
        let itemSavedToDB = (appDatabase.downloadRepository as! DownloadRepositoryMock).dataStore.downloaditems.filter({ $0.id == lesson.id }).first
        
        self.continueAfterFailure = false
        
        XCTAssertNotNil(itemSavedToDB)
        XCTAssertTrue(downloadService.isDownlaoding)
        XCTAssertTrue(downloadService.downloadStarted)
        
    }
    
    func testDownloadExpectNotStartPreviousDownloadInProgress() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        (appDatabase.downloadRepository as! DownloadRepositoryMock).expectation = appDatabaseExpectation

        //Set download service download in progress
        downloadService.isDownlaoding = true
        
        let lesson = LessonModel(id: 1, name: "", lessonDescription: "", thumbnailUrl: "", videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.download(lesson: lesson)
        
        wait(for: [appDatabaseExpectation], timeout: 2)
        
        let itemSavedToDB = (appDatabase.downloadRepository as! DownloadRepositoryMock).dataStore.downloaditems.filter({ $0.id == lesson.id }).first
        
        self.continueAfterFailure = false
        
        XCTAssertNotNil(itemSavedToDB)
        XCTAssertTrue(downloadService.isDownlaoding)
        XCTAssertFalse(downloadService.downloadStarted)
        
    }
    
    func testCancelDownload() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        let downloadServiceExpectation = XCTestExpectation(description: "downloadServiceExpectation")
        let filemanagerExpectation = XCTestExpectation(description: "filemanagerExpectation")
        
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.expectation = appDatabaseExpectation
        downloadService.cancelExepectation = downloadServiceExpectation
        fileManager.removeExpectation = filemanagerExpectation
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id, name: "", lessonDescription: "", thumbnailUrl: "", videoUrl: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.cancelDownloadFor(id: lesson.id)
        
        wait(for: [appDatabaseExpectation,downloadServiceExpectation, filemanagerExpectation], timeout: 2)
        
        
        self.continueAfterFailure = false
        
        XCTAssertFalse(downloadService.isDownlaoding)
        XCTAssertTrue(fileManager.urlRemoved)
        XCTAssertEqual(downloadRepository.dataStore.downloaditems.count, 0)
        
    }
    
    func testCancelDownloadAndStartNextAutomatically() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        let downloadServiceExpectation = XCTestExpectation(description: "downloadServiceExpectation")
        
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.expectation = appDatabaseExpectation
        downloadService.startExepectation = downloadServiceExpectation

        downloadRepository.dataStore = DataStoreDownloadTwoItemsSecondNotDownloaded()
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id, name: "", lessonDescription: "", thumbnailUrl: "", videoUrl: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.cancelDownloadFor(id: lesson.id)
        
        wait(for: [appDatabaseExpectation,downloadServiceExpectation], timeout: 2)
        
        
        self.continueAfterFailure = false
        
        XCTAssertTrue(downloadService.isDownlaoding)
        XCTAssertEqual(downloadRepository.dataStore.downloaditems.count, 1)
    }
    
    func testIsLessonInDownloadQueueExist() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let exist = downlaodManager.isLessonInDonwloadQueue(id:downloadRepository.dataStore.downloaditems.first!.id )
        
        XCTAssertTrue(exist)
    }
    
    func testIsLessonInDownloadQueueNotExist() {
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let notExist = downlaodManager.isLessonInDonwloadQueue(id: 0)
        
        XCTAssertFalse(notExist)
    }
    
    func testIsLessonInDownloadComplete() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)

        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let complete = downlaodManager.isLessonDownloadComplete(id:downloadRepository.dataStore.downloaditems.first!.id )
        
        XCTAssertTrue(complete)
    }
    
    func testIsLessonInDownloadNotComplete() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.dataStore = DataStoreDownloadOneItemDownloadNotComplete()
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let notComplete = downlaodManager.isLessonDownloadComplete(id:downloadRepository.dataStore.downloaditems.first!.id )
        
        XCTAssertFalse(notComplete)
    }
    
    func testIsLessonInDownloadCompleteNotExistInDatabase() {
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let notComplete = downlaodManager.isLessonDownloadComplete(id:0 )
        
        XCTAssertFalse(notComplete)
    }
    
    func testGetLessonLocalUrlForDownloadedLesson() {
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let url = downlaodManager.getLessonLocalUrl(id:downloadRepository.dataStore.downloaditems.first!.id )
        
        XCTAssertNotEqual(url, "")
    }
    
    func testGetLessonLocalUrlForNotDownloadedLesson() {
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.dataStore = DataStoreDownloadOneItemDownloadNotComplete()
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let url = downlaodManager.getLessonLocalUrl(id:downloadRepository.dataStore.downloaditems.first!.id )
        
        XCTAssertEqual(url, "")
    }
    
    func testGetLessonLocalUrlForLessonNotInDatabase() {
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let url = downlaodManager.getLessonLocalUrl(id:0 )
        
        XCTAssertEqual(url, "")
    }
    
    func testDownloadDelegateComplete() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        let filemanagerRemoveExpectation = XCTestExpectation(description: "filemanagerRemoveExpectation")
        let filemanagerCopyExpectation = XCTestExpectation(description: "filemanagerCopyExpectation")
        let expectationSubject = XCTestExpectation(description: "expectationSubject")
        
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.dataStore = DataStoreDownloadOneItemNotDownloadedEmptyLocalUrl()
        downloadRepository.expectation = appDatabaseExpectation
        fileManager.removeExpectation = filemanagerRemoveExpectation
        fileManager.copyExpectation = filemanagerCopyExpectation
        
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.downloadCompleteSubject
            .sink { _ in
                expectationSubject.fulfill()
            }.store(in: &cancelable)
        
        downloadService.delegate?.didFinishDownloadFor(lesson: downloadRepository.dataStore.downloaditems.first!,
                                                       location: URL(string: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)!)
        
        
        wait(for: [appDatabaseExpectation,filemanagerRemoveExpectation, filemanagerCopyExpectation, expectationSubject], timeout: 2)
        
        
        self.continueAfterFailure = false
        XCTAssertTrue(fileManager.urlRemoved)
        XCTAssertTrue(fileManager.fileCopySuccessful)
        XCTAssertFalse(downloadRepository.dataStore.downloaditems.first!.localVideoUrl.isEmpty)
        XCTAssertTrue(downloadRepository.dataStore.downloaditems.first!.isDownloaded)
   
    }
    
    func testDownloadDelegateCompleteAndStartNextDownload() {
        let appDatabaseExpectation = XCTestExpectation(description: "appDatabaseExpectation")
        let downloadServiceExpectation = XCTestExpectation(description: "downloadServiceExpectation")
        let filemanagerRemoveExpectation = XCTestExpectation(description: "filemanagerRemoveExpectation")
        let filemanagerCopyExpectation = XCTestExpectation(description: "filemanagerCopyExpectation")
        let expectationSubject = XCTestExpectation(description: "expectationSubject")
        
        
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.dataStore = DataStoreDownloadTwoItems()
        downloadRepository.expectation = appDatabaseExpectation
        fileManager.removeExpectation = filemanagerRemoveExpectation
        fileManager.copyExpectation = filemanagerCopyExpectation
        downloadService.startExepectation = downloadServiceExpectation
        
        
        let downlaodManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        downlaodManager.downloadCompleteSubject
            .sink { _ in
                expectationSubject.fulfill()
            }.store(in: &cancelable)
        
        downloadService.delegate?.didFinishDownloadFor(lesson: downloadRepository.dataStore.downloaditems.first!,
                                                       location: URL(string: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)!)
        
        
        wait(for: [appDatabaseExpectation,filemanagerRemoveExpectation, filemanagerCopyExpectation, expectationSubject, downloadServiceExpectation], timeout: 2)
        
        
        self.continueAfterFailure = false
        XCTAssertTrue(fileManager.urlRemoved)
        XCTAssertTrue(fileManager.fileCopySuccessful)
        XCTAssertFalse(downloadRepository.dataStore.downloaditems.first!.localVideoUrl.isEmpty)
        XCTAssertTrue(downloadRepository.dataStore.downloaditems.first!.isDownloaded)
        XCTAssertTrue(downloadService.isDownlaoding)
        XCTAssertTrue(downloadService.downloadStarted)
   
    }
    
    func testDownloadProgressDelegate() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        let expectation = XCTestExpectation(description: "expectation")
        let downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let progress: Float = 0.5
        var newProgress:Float = 0
        downloadManager.downloadProgressSubject
            .sink { (id: Int32, progress: Float) in
                newProgress = progress
                expectation.fulfill()
            }.store(in: &cancelable)
        
        downloadService.delegate?.downloadProgressFor(lesson: downloadRepository.dataStore.downloaditems.first!, progress: progress)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(progress, newProgress)
    }

    
    override func tearDown() {
        appDatabase = nil
        downloadService = nil
        fileManager = nil
    }
}
