//
//  BaseNetworkRequest.swift
//  NetworkCore
//
//  Created by Ahmed Mohiy on 16/01/2022.
//

import Foundation

protocol BaseNetworkRequest {
    var apiEndPoint: String {get set}
    func build(baseUrl: String) -> URLRequest?
}
