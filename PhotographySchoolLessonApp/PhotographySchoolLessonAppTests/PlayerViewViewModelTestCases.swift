//
//  PlayerViewViewModelTestCases.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import XCTest
import AppModels
import AVKit
@testable import PhotographySchoolLessonApp

final class PlayerViewViewModelTestCases: XCTestCase {
    var appDatabase: AppDatabaseMock!
    var downloadService: DownloadServiceMock!
    var fileManager: FileManagerMock!
    
    
    override func setUp() {
        appDatabase = AppDatabaseMock()
        downloadService = DownloadServiceMock()
        fileManager = FileManagerMock()
    }
    
    func testGetAVPlayerWithLocalUrl() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        
        let downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)
        let url = URL(string: downloadRepository.dataStore.downloaditems.first!.localVideoUrl)!
        let lessonLocalUrl = URL(fileURLWithPath: url.path)
        
        let viewModel = PlayerViewControllerViewModel(lesson: lesson, downloadManager: downloadManager)
        let player = viewModel.getAvPlayer()
        let playerUrl = ((player?.currentItem?.asset) as? AVURLAsset)?.url
        self.continueAfterFailure = false
        
        XCTAssertNotNil(player)
        XCTAssertNotNil(playerUrl)
        XCTAssertEqual(playerUrl!.absoluteString, lessonLocalUrl.absoluteString)
    }
    
    func testGetAVPlayerWithRemoteUrl() {
        let downloadRepository = (appDatabase.downloadRepository as! DownloadRepositoryMock)
        downloadRepository.dataStore = DataStoreDownloadTwoItems()
        
        let downloadManager = DownloadManager(databaseController: appDatabase, downloadService: downloadService, fileManager: fileManager)
        
        let lesson = LessonModel(id: downloadRepository.dataStore.downloaditems.first!.id,
                                 name: "",
                                 lessonDescription: "",
                                 thumbnailUrl: "",
                                 videoUrl: downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl)
        
        let lessonLocalUrl = downloadRepository.dataStore.downloaditems.first!.remoteVideoUrl
        
        let viewModel = PlayerViewControllerViewModel(lesson: lesson, downloadManager: downloadManager)
        let player = viewModel.getAvPlayer()
        let playerUrl = ((player?.currentItem?.asset) as? AVURLAsset)?.url
        self.continueAfterFailure = false
        
        XCTAssertNotNil(player)
        XCTAssertNotNil(playerUrl)
        XCTAssertEqual(playerUrl!.absoluteString, lessonLocalUrl)
    }
    
    
    override func tearDown() {
        appDatabase = nil
        downloadService = nil
        fileManager = nil
    }
}
