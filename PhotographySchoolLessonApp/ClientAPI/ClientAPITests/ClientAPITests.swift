//
//  ClientAPITests.swift
//  ClientAPITests
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import XCTest
import AppModels
import Combine
@testable import ClientAPI

final class ClientAPITests: XCTestCase {

    var cancelable =  Set<AnyCancellable>()
  
    func testFetchLessonsSuccess() {
        let networkEngine = NetworkEngineMockSuccess()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var lessons: [LessonModel] = []
        
        let expectation = XCTestExpectation(description: "testFetchLessonsSuccess")
        controller.lessonNetworkManager.fetchLessons()
            .sink { _ in
                
            } receiveValue: { lessonsList in
                lessons = lessonsList
                expectation.fulfill()
            }.store(in: &cancelable)
        
        networkEngine.publisher.send(networkEngine.getData())
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(lessons.count, 1)
        let mockLesson = networkEngine.getFirstLesson()
        XCTAssertEqual(lessons.first!.id, mockLesson.id)
        XCTAssertEqual(lessons.first!.name, mockLesson.name)
        XCTAssertEqual(lessons.first!.lessonDescription, mockLesson.lessonDescription)
        XCTAssertEqual(lessons.first!.thumbnailUrl, mockLesson.thumbnailUrl)
        XCTAssertEqual(lessons.first!.videoUrl, mockLesson.videoUrl)
        
    }
    
    func testFetchLessonsBadReuest() {
        let networkEngine = NetworkEngineMockBadRequest()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .notFound
        let expectation = XCTestExpectation(description: "testFetchLessonsBadReuest")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.badRequest)
        
    }
    
    func testFetchLessonsNotFound() {
        let networkEngine = NetworkEngineMockNotFound()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .badRequest
        let expectation = XCTestExpectation(description: "testFetchLessonsNotFound")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.notFound)
        
    }
    
    func testFetchLessonsServerError() {
        let networkEngine = NetworkEngineMockServerError()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .badRequest
        let expectation = XCTestExpectation(description: "testFetchLessonsServerError")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.serverError)
        
    }
    
    func testFetchLessonsUnAuthorized() {
        let networkEngine = NetworkEngineMockUnAuthorized()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .badRequest
        let expectation = XCTestExpectation(description: "testFetchLessonsUnAuthorized")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.unAuthorized)
        
    }

    
    func testFetchLessonsInvalidUrl() {
        let networkEngine = NetworkEngineMockInvalidUrl()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .badRequest
        let expectation = XCTestExpectation(description: "testFetchLessonsInvalidUrl")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.invalidUrl)
        
    }
    
    func testFetchLessonsInvalidData() {
        let networkEngine = NetworkEngineMockInvalidData()
        let controller = ClientApiControllerMock(engine: networkEngine)
        
        var err: NetworkEngineError = .badRequest
        let expectation = XCTestExpectation(description: "testFetchLessonsInvalidData")
        controller.lessonNetworkManager.fetchLessons()
            .sink { completion in
                if case let .failure(error) = completion,
                   let error = error as? NetworkEngineError {
                    err = error
                }
                
                expectation.fulfill()
            } receiveValue: { _ in}.store(in: &cancelable)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(err, NetworkEngineError.invalidData)
        
    }

}
