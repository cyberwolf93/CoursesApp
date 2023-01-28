//
//  NetworkEngineMockInvali.swift
//  ClientAPITests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import ClientAPI
import Foundation
import Combine

class NetworkEngineMockNotFound: NetworkEngineProtocol {
    
    public var urlRequest: URLRequest?
    
    public init() {}
    
    public func excute() -> AnyPublisher<Data, Error> {
        return Fail(error: NetworkEngineError.notFound).eraseToAnyPublisher()
    }
}



