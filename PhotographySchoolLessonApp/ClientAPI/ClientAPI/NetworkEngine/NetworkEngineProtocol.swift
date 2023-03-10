//
//  NetworkEngineProtocol.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation
import Combine

public protocol NetworkEngineProtocol {
    var urlRequest: URLRequest? {get set}
    func excute() -> AnyPublisher<Data, Error>
}
