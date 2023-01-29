//
//  FileManagerMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
import XCTest

class FileManagerMock: FileManager {
    
    var urlRemoved = false
    var fileCopySuccessful = false
    var removeExpectation: XCTestExpectation?
    var copyExpectation: XCTestExpectation?
    
    override func removeItem(at URL: URL) throws {
        urlRemoved = true
        removeExpectation?.fulfill()
    }
    
    override func copyItem(at srcURL: URL, to dstURL: URL) throws {
        fileCopySuccessful = true
        copyExpectation?.fulfill()
    }
}
