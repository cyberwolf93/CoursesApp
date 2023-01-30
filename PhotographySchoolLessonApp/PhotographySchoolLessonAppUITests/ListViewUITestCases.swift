//
//  PhotographySchoolLessonAppUITests.swift
//  PhotographySchoolLessonAppUITests
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import XCTest
import PhotographySchoolLessonApp

final class ListViewUITestCases: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["-UITestLaunch"]
        app.launch()
        continueAfterFailure = false
    }

    func testListCellsAppears() {
        
        let lessonTitle = app.navigationBars["Lessons"].staticTexts["Lessons"]
        XCTAssertTrue(lessonTitle.exists)
        
        let cells = app.collectionViews.cells
        XCTAssertNotEqual(cells.count, 0)
        
    }
    
    func testPlayButtonAction() {
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        let playButton =  app.buttons[DetailsAccessibilityIDType.playButton.rawValue]
        XCTAssertTrue(playButton.exists)
        
        playButton.tap()
        
        let playerView = app.otherElements[PlayerAccessibilityIDType.parentView.rawValue]
        XCTAssertTrue(playerView.exists)
    }
    
    func testTitleMatch() {
        
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        let cellTitle = cell.staticTexts[ListAccessibilityIDType.cellTitle.rawValue].label
        cell.tap()
        
        let detailsTitle = app.staticTexts[DetailsAccessibilityIDType.title.rawValue]
        XCTAssertTrue(detailsTitle.exists)
        XCTAssertEqual(cellTitle, detailsTitle.label)
    }
    
    func testNexestLessonButton() {
        
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        
        let nextButton = app.buttons[DetailsAccessibilityIDType.nextLessonButton.rawValue]
        XCTAssertTrue(nextButton.exists)
        
        let currentTitle = app.staticTexts[DetailsAccessibilityIDType.title.rawValue]
        nextButton.tap()
        let nextTitle = app.staticTexts[DetailsAccessibilityIDType.title.rawValue]
        
        XCTAssertNotEqual(currentTitle, nextTitle)
    }
    
    func testNextButtonHiddenForLastCell() {
        
        var cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        app.navigationBars.buttons["Lessons"].tap()
        cell = app.collectionViews.cells.element(boundBy: app.collectionViews.cells.count - 1)
        var newcell = app.collectionViews.cells.element(boundBy: 0)
        repeat {
            cell = app.collectionViews.cells.element(boundBy: app.collectionViews.cells.count - 1)
            app.swipeUp()
            newcell = app.collectionViews.cells.element(boundBy: app.collectionViews.cells.count - 1)
        } while(cell.staticTexts[ListAccessibilityIDType.cellTitle.rawValue].label != newcell.staticTexts[ListAccessibilityIDType.cellTitle.rawValue].label)
        
        cell.tap()
        let nextButton = app.buttons[DetailsAccessibilityIDType.nextLessonButton.rawValue]
        XCTAssertFalse(nextButton.exists)
        
    }
    
    func testDownloadButtonExist() {
        
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        
        let downloadButton =  app.navigationBars.buttons[DetailsAccessibilityIDType.downlaodButton.rawValue]
        XCTAssertTrue(downloadButton.exists)
    }
    
    func testDownloadViewAppearsOnClickingDownloadbutton() {
        
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        
        let downloadButton =  app.navigationBars.buttons[DetailsAccessibilityIDType.downlaodButton.rawValue]
        
        let separatorView = app.otherElements[DetailsAccessibilityIDType.downloadViewSeparator.rawValue]
        let downloadingLabel = app.staticTexts[DetailsAccessibilityIDType.downloadLabel.rawValue]
        let progressView = app.progressIndicators[DetailsAccessibilityIDType.downloadProgressView.rawValue]
        XCTAssertFalse(separatorView.exists)
        XCTAssertFalse(downloadingLabel.exists)
        XCTAssertFalse(progressView.exists)
        
        downloadButton.tap()
        
        XCTAssertTrue(separatorView.exists)
        XCTAssertTrue(downloadingLabel.exists)
        XCTAssertTrue(progressView.exists)
    }
    
    func testDownloadViewDisappearsOnClickingDownloadbuttonAgain() {
        
        let cell =  app.collectionViews.cells.element(boundBy: 0)
        cell.tap()
        
        let downloadButton =  app.navigationBars.buttons[DetailsAccessibilityIDType.downlaodButton.rawValue]
        
        let separatorView = app.otherElements[DetailsAccessibilityIDType.downloadViewSeparator.rawValue]
        let downloadingLabel = app.staticTexts[DetailsAccessibilityIDType.downloadLabel.rawValue]
        let progressView = app.progressIndicators[DetailsAccessibilityIDType.downloadProgressView.rawValue]
        XCTAssertFalse(separatorView.exists)
        XCTAssertFalse(downloadingLabel.exists)
        XCTAssertFalse(progressView.exists)
        
        downloadButton.tap()
        
        XCTAssertTrue(separatorView.exists)
        XCTAssertTrue(downloadingLabel.exists)
        XCTAssertTrue(progressView.exists)
        
        downloadButton.tap()
        
        XCTAssertFalse(separatorView.exists)
        XCTAssertFalse(downloadingLabel.exists)
        XCTAssertFalse(progressView.exists)
    }

   
}
