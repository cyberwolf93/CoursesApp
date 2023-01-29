//
//  ClienApiControllerMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

@testable import ClientAPI
import Foundation

class ClienApiControllerMock: ClienApiController {
    
    let networkManager = LessonNetworkManagerMock(engine: NetworkEngine())
    
    public override var lessonNetworkManager: LessonNetworkManager {
        return networkManager
    }
}
