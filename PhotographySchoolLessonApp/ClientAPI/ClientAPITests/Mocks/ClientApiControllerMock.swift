//
//  ClientApiControllerMock.swift
//  ClientAPITests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import ClientAPI
import Foundation

class ClientApiControllerMock: ClienApiController {
    
    let engine: NetworkEngineProtocol
    
    init(engine: NetworkEngineProtocol) {
        self.engine = engine
    }
    
    override public var lessonNetworkManager: LessonNetworkManager {
        return LessonNetworkManager(engine: engine)
    }
    
}
