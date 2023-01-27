//
//  LessonNetworkManager.swift
//  ClientAPI
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import Combine
import AppModels

public class LessonNetworkManager: NetworkManager {
    
    public override init(engine: NetworkEngineProtocol) {
        super.init(engine: engine)
    }
    
    public func fetchLessons() -> AnyPublisher<[LessonModel], Error> {
        let base_url = PlistManager.default.baseUrl
        let lessonRequest = LessonRequest()
        guard let urlRequest = lessonRequest.build(baseUrl: base_url) else {
            return Fail(error: NetworkEngineError.badRequest).eraseToAnyPublisher()
        }
        self.engine.urlRequest = urlRequest
        return self.engine.excute()
            .decode(type: LessonsResponse.self, decoder: JSONDecoder())
            .map ({ lessons in
                return lessons.lessons.map { $0.convertTo() }
            }).eraseToAnyPublisher()
        
    }
}
