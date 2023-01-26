//
//  NetworkEngineError.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public enum NetworkEngineError: Error {
    case invalidData
    case invalidUrl
    case badRequest
    case unAuthorized
    case notFound
    case serverError
}


extension NetworkEngineError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "network_core_invalid_url"
        case .invalidData:
            return "network_core_nod_data"
        case .badRequest:
            return  "network_core_bad_request"
        case .serverError:
            return  "network_core_server_error"
        case .unAuthorized:
            return  "network_core_server_unauthorized"
        case .notFound:
            return  "network_core_server_not_found"
        }
    }
}
