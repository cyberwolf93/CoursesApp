//
//  PlistManager.swift
//  linkedin_client_api
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

class PlistManager {
    static let `default`: PlistManager = PlistManager()
    static let bundleIdentifier = "com.amohiy.photographyschoollessonapp.clientapi"
    
    
    var baseUrl: String {
        if let dictionary = Bundle(identifier: Self.bundleIdentifier)?.infoDictionary {
            return dictionary["base_url"] as? String ?? ""
        }
        return  ""
    }
    
}
