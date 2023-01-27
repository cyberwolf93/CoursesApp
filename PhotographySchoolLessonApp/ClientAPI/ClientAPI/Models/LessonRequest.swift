//
//  LessonRequest.swift
//  ClientAPI
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation

struct LessonRequest: BaseNetworkRequest {
    var apiEndPoint: String = "/test-api/lessons"
    
    func build(baseUrl: String) -> URLRequest? {
        guard let url = URL(string: baseUrl + apiEndPoint) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}
