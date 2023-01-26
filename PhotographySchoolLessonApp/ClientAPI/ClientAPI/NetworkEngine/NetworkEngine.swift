//
//  NetworkEngine.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation


public class NetworkEngine: NetworkEngineProtocol {
    
    public var urlRequest: URLRequest?
    
    public init() {}
    
    public func excute(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = self.urlRequest else {
            completion(.failure(NetworkEngineError.invalidUrl))
            return
        }
        print("request url: \(request.url)")
        print("request body: \(String(data: request.httpBody ?? Data(), encoding: .utf8))")
        let task  = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(error!))
            } else {
                if let response = response as? HTTPURLResponse {
                    print("response code: \(response.statusCode)")
                    if response.statusCode >= 200, response.statusCode < 400 {
                        if let data = data {
                            // success case return response data
                            completion(.success(data))
                        } else {
                            // invalid data in the response code is 200 but there is no data to be returned
                            completion(.failure(NetworkEngineError.invalidData))
                        }
                        
                    } else if (response.statusCode == 404) {
                        // Not found if the response code is 404
                        completion(.failure(NetworkEngineError.notFound))
                    } else if (response.statusCode == 401) {
                        // UNAuthorized if the response code is 401
                        completion(.failure(NetworkEngineError.unAuthorized))
                    } else if response.statusCode >= 400, response.statusCode < 500 {
                        // Bad request if the response code between 400 and 500
                        completion(.failure(NetworkEngineError.badRequest))
                    } else {
                        // Server erro if the response code above 500
                        completion(.failure(NetworkEngineError.serverError))
                    }
                } else {
                    // return invalid data if the response can't be parsed
                    completion(.failure(NetworkEngineError.invalidData))
                }
            }
        }
        
        task.resume()
    }
    
    
}
