//
//  ClienApiController.swift
//  ClientAPI
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation

public class ClienApiController {
    public static let `default`: ClienApiController = ClienApiController()
    
    public var lessonNetworkManager: LessonNetworkManager {
        let engine = NetworkEngine()
        return LessonNetworkManager(engine: engine)
    }
}
