//
//  NetworkEngineProtocol.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation


public protocol NetworkEngineProtocol {
    var urlRequest: URLRequest? {get set}
    func excute(completion: @escaping (Result<Data, Error>) -> Void)
}
