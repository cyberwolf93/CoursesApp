//
//  DownloadServiceMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
import AppModels
import XCTest
@testable import PhotographySchoolLessonApp

class DownloadServiceMock: DownloadService {
    
    var startExepectation: XCTestExpectation?
    var cancelExepectation: XCTestExpectation?
    var downloadStarted = false
    override func setupDownloadingSession(lesson: DownloadItemModel) {
        self.isDownlaoding = true
        downloadStarted = true
        startExepectation?.fulfill()
    }
    
    override func isDownloadInProgress() -> Bool {
        return self.isDownlaoding
    }
    
    override func cancelDownloadFor(lesson: DownloadItemModel) {
        self.lesson = nil
        self.isDownlaoding = false
        cancelExepectation?.fulfill()
    }
}


