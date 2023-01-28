//
//  NetworkEngineMockSuccess.swift
//  ClientAPITests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//


@testable import ClientAPI
import Foundation
import Combine
import AppModels

class NetworkEngineMockSuccess: NetworkEngineProtocol {
    
    public var urlRequest: URLRequest?
    var publisher: PassthroughSubject<Data, Error>!
    
    public init() {}
    
    public func excute() -> AnyPublisher<Data, Error> {
        
        publisher =  PassthroughSubject<Data, Error>()
        
        return publisher.eraseToAnyPublisher()
    }
    
    public func getFirstLesson() -> LessonModel {
        return LessonModel(id: 950,
                           name: "The Key To Success In iPhone Photography",
                           lessonDescription: "What\\u2019s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there\\u2019s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!",
                           thumbnailUrl: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
                           videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4")
    }
    
    public func getData() -> Data {
        let lesson = self.getFirstLesson()
        let object:[String:Any] = [
            "id": lesson.id,
            "name": lesson.name,
            "description": lesson.lessonDescription,
            "thumbnail": lesson.thumbnailUrl,
            "video_url": lesson.videoUrl
        ]
        
        return try! JSONSerialization.data(withJSONObject: ["lessons":[object]])
    }
}
