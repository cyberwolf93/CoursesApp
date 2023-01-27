//
//  NetworkEngine.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation
import Combine

public class NetworkEngine: NetworkEngineProtocol {
    
    public var urlRequest: URLRequest?
    
    public init() {}
    
    public func excute() -> AnyPublisher<Data, Error> {
        guard let request = self.urlRequest else {
            return Fail(error: NetworkEngineError.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    // return invalid data if the response can't be parsed
                    throw NetworkEngineError.invalidData
                }
                
                if response.statusCode == 404  {
                    // Not found if the response code is 404
                    throw NetworkEngineError.notFound
                }
                
                if response.statusCode == 401  {
                    // UNAuthorized if the response code is 401
                    throw NetworkEngineError.unAuthorized
                }
                
                if response.statusCode >= 400, response.statusCode < 500  {
                    // Bad request if the response code between 400 and 500
                    throw NetworkEngineError.badRequest
                }
                
                if response.statusCode >= 500  {
                    // UNAuthorized if the response code is 401
                    throw NetworkEngineError.serverError
                }
                
                if response.statusCode >= 200, response.statusCode < 400  {
                    return data
                }
                
                // invalid data in the response code is 200 but there is no data to be returned
                throw NetworkEngineError.invalidData
                
                
            }.eraseToAnyPublisher()
    }
}
