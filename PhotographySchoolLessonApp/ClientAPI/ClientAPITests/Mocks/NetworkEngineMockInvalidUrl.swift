//
//  NetworkEngineMock.swift
//  ClientAPITests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import ClientAPI
import Foundation
import Combine

class NetworkEngineMockInvalidUrl: NetworkEngineProtocol {
    
    public var urlRequest: URLRequest?
    
    public init() {}
    
    public func excute() -> AnyPublisher<Data, Error> {
        guard let _ = self.urlRequest else {
            return Fail(error: NetworkEngineError.invalidUrl).eraseToAnyPublisher()
        }
        
        return Fail(error: NetworkEngineError.invalidUrl).eraseToAnyPublisher()
    }
}

