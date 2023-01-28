//
//  DownloadRepositoryTest.swift
//  AppDataBaseTests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import AppDataBase
import AppModels
import XCTest

final class DownloadRepositoryTest: XCTestCase {

    var appDatabase: AppDatabaseMock!
    var databaseStoreMock: DatabaseStoreMock!
    
    override func setUp() {
        super.setUp()
        appDatabase = AppDatabaseMock()
        databaseStoreMock = DatabaseStoreMock(appDatabaseManager: appDatabase.appDatabaseManager as! AppDatabaseManagerMock)
    }
    
    func testGetAllDownload() {
        let downloadDB = databaseStoreMock.downloaditems
        databaseStoreMock.appDatabaseManager.saveContext()
        let downloadItems = appDatabase.downloadRepository.getAll()
        
        XCTAssertEqual(downloadItems.count, downloadDB.count)
        XCTAssertGreaterThan(downloadItems.first!.id, 0)
        XCTAssertNotEqual(downloadItems.first!.remoteVideoUrl, "")
        XCTAssertNotEqual(downloadItems.first!.localVideoUrl, "")
        
    }
    
    func testGetWithIdAndDownloadExist() {
        let downloadDB = databaseStoreMock.downloaditems
        databaseStoreMock.appDatabaseManager.saveContext()
        let item = appDatabase.downloadRepository.get(with: downloadDB.first!.id)
        
        XCTAssertNotNil(item)
    }
    
    func testGetWithIdAndDownloadDoesnotExist() {
        let item = appDatabase.lessonRepository.get(with: 20)
        XCTAssertNil(item)
    }
    
    func testGetDowloadedItemsOnly() {
        let downloadDB = databaseStoreMock.downloaditems
        databaseStoreMock.appDatabaseManager.saveContext()
        let items = appDatabase.downloadRepository.getAllDownloadedItem()
        
        let downloadedDB = downloadDB.filter({ $0.isDownloaded })
        
        XCTAssertEqual(items.count, downloadedDB.count)
        XCTAssertEqual(items.first!.id, downloadedDB.first!.id)
        XCTAssertEqual(items.first!.isDownloaded, downloadedDB.first!.isDownloaded)
    }
    
    func testAddDownloadItem() {
        let item = DownloadItemModel(id: 1,
                                     remoteVideoUrl: "test",
                                     localVideoUrl: "test",
                                     isDownloaded: true)
        appDatabase.downloadRepository.add(downloadItem: item)
        
        let savedDownloads =  try! appDatabase.appDatabaseManager.persistentContainer.viewContext.fetch(DownloadItem.fetchRequest())
        
        XCTAssertEqual(savedDownloads.count, 1)
        XCTAssertEqual(savedDownloads.first!.id, item.id)
        XCTAssertEqual(savedDownloads.first!.isDownloaded, item.isDownloaded)
        XCTAssertEqual(savedDownloads.first!.remoteVideoUrl, item.remoteVideoUrl)
        XCTAssertEqual(savedDownloads.first!.localVideoUrl, item.localVideoUrl)
        
    }
    
    func testAddMoreThanOneDownloadItem() {
        let item = DownloadItemModel(id: 1,
                                     remoteVideoUrl: "test",
                                     localVideoUrl: "test",
                                     isDownloaded: true)
        appDatabase.downloadRepository.add(downloadItems: [item])
        
        let savedDownloads =  try! appDatabase.appDatabaseManager.persistentContainer.viewContext.fetch(DownloadItem.fetchRequest())
        
        XCTAssertEqual(savedDownloads.count, 1)
        XCTAssertEqual(savedDownloads.first!.id, item.id)
        XCTAssertEqual(savedDownloads.first!.isDownloaded, item.isDownloaded)
        XCTAssertEqual(savedDownloads.first!.remoteVideoUrl, item.remoteVideoUrl)
        XCTAssertEqual(savedDownloads.first!.localVideoUrl, item.localVideoUrl)
        
    }
    
    func testUpdateDownloadItem() {
        let downloadDB = databaseStoreMock.downloaditems
        databaseStoreMock.appDatabaseManager.saveContext()
        let item = DownloadItemModel(id: downloadDB.first!.id,
                                     remoteVideoUrl: "",
                                     localVideoUrl: "",
                                     isDownloaded: downloadDB.first!.isDownloaded)
        appDatabase.downloadRepository.Update(item: item, localUrl: "test", isDownloaded: true)
        
        let savedDownloads =  try! appDatabase.appDatabaseManager.persistentContainer.viewContext.fetch(DownloadItem.fetchRequest())
        
        let savedDownloadItem = savedDownloads.filter({ $0.id == item.id }).first!
        
        self.continueAfterFailure = false
        XCTAssertEqual(savedDownloadItem.id, item.id)
        XCTAssertEqual(savedDownloadItem.localVideoUrl, "test")
        XCTAssertEqual(savedDownloadItem.isDownloaded, true)
        
        
    }
    
    
    
    
    
    
    override func tearDown() {
        super.tearDown()
        appDatabase = nil
        databaseStoreMock = nil
    }
   
}
