//
//  LessonListViewModelTestCases.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import XCTest
import Combine
import AppModels
@testable import PhotographySchoolLessonApp

final class LessonListViewModelTestCases: XCTestCase {

    var appDatabase: AppDatabaseMock!
    var clientApi: ClienApiControllerMock!
    var cancelable =  Set<AnyCancellable>()
    
    override func setUp() {
        appDatabase = AppDatabaseMock()
        clientApi = ClienApiControllerMock()
    }
    
    func testGetLessonsLocallyNoInternetConnection() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        lessonRepository.dataStore = DataStoreLessonOneItemLocal()
        
        
        let viewModel = LessonListViewModelMock()
        viewModel.deviceIsConectedToInternet = false // disable internet connection
        viewModel.appDatabase = appDatabase
        viewModel.clientApi = clientApi
        
        let expectation = XCTestExpectation(description: "expectation")
        var fetchedLesson: [LessonModel] = []
        
        viewModel.$lessonList
            .sink { lessonsList in
                fetchedLesson = lessonsList
                expectation.fulfill()
            }.store(in: &cancelable)
        
        viewModel.getLessons()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(fetchedLesson.count, lessonRepository.dataStore.lessons.count)
        XCTAssertEqual(fetchedLesson.first!.id, lessonRepository.dataStore.lessons.first!.id)
        
    }
    
    func testGetLessonsRemoteInternetConnectionExist() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        lessonRepository.dataStore = DataStoreLessonOneItemRemote()
        let databaseexpectation = XCTestExpectation(description: "expectation")
        lessonRepository.addExpectation = databaseexpectation
        
        let viewModel = LessonListViewModelMock()
        viewModel.deviceIsConectedToInternet = true // enable internet connection
        viewModel.appDatabase = appDatabase
        viewModel.clientApi = clientApi
        
        let expectation = XCTestExpectation(description: "expectation")
        var fetchedLesson: [LessonModel] = []
        
        viewModel.$lessonList
            .sink { lessonsList in
                fetchedLesson = lessonsList
                expectation.fulfill()
            }.store(in: &cancelable)
        
        viewModel.getLessons()
        
        (clientApi.lessonNetworkManager as! LessonNetworkManagerMock)
            .publisher.send(lessonRepository.dataStore.lessons)
        
        wait(for: [expectation, databaseexpectation], timeout: 1)
        
        XCTAssertEqual(fetchedLesson.count, lessonRepository.dataStore.lessons.count)
        XCTAssertEqual(fetchedLesson.first!.id, lessonRepository.dataStore.lessons.first!.id)
        
    }
    
    func testGetNextLessonsAfterCurrentLesson() {
        let lessonRepository = (appDatabase.lessonRepository as! LessonRepositoryMock)
        
        let viewModel = LessonListViewModelMock()
        viewModel.lessonList = lessonRepository.dataStore.lessons
        viewModel.appDatabase = appDatabase
        viewModel.clientApi = clientApi
        
        let nextLessons = viewModel.getNextLessonsAfter(lesson: lessonRepository.dataStore.lessons.first!)
        
        XCTAssertEqual(nextLessons.count, lessonRepository.dataStore.lessons.count - 1)
        // nextLesson should be the inversion of the current list
        XCTAssertEqual(nextLessons.first!.id, lessonRepository.dataStore.lessons.last!.id)
    }
    
    
    override func tearDown() {
        appDatabase = nil
        clientApi = nil
    }

}
