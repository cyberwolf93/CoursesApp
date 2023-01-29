//
//  DownloadRepositoryMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
@testable import AppDataBase
import AppModels
import XCTest

class DownloadRepositoryMock: DownloadRepository {
    
    var dataStore: DataStoreDownload = DataStoreDownloadOneItemDownloaded()
    var expectation: XCTestExpectation?
    
    override func getAll() -> [DownloadItemModel] {
        return dataStore.downloaditems
    }
    
    override func Update(item: DownloadItemModel, localUrl: String, isDownloaded: Bool) {
        dataStore.downloaditems = [
            DownloadItemModel(id: item.id,
                              remoteVideoUrl: item.remoteVideoUrl,
                              localVideoUrl: localUrl,
                              isDownloaded: isDownloaded)
        ]
        expectation?.fulfill()
    }
    
    override func deleteItem(with id: Int32) {
        guard let index = dataStore.downloaditems.firstIndex(where: { id == $0.id }) else {
            return
        }
        dataStore.downloaditems.remove(at: index)
        expectation?.fulfill()
    }
    
    override func add(downloadItem: DownloadItemModel) {
        dataStore.downloaditems.append(downloadItem)
        expectation?.fulfill()
    }
}
