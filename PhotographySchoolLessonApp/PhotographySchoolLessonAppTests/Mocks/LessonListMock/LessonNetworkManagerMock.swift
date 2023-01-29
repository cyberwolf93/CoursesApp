//
//  LessonNetworkManagerMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

@testable import ClientAPI
import Foundation
import AppModels
import Combine
import XCTest

class LessonNetworkManagerMock: LessonNetworkManager {
    
    var publisher:PassthroughSubject<[LessonModel], Error>!
    
    override func fetchLessons() -> AnyPublisher<[LessonModel], Error> {
        
        publisher = PassthroughSubject<[LessonModel], Error>()
        
        return publisher.eraseToAnyPublisher()
    }
    
}
