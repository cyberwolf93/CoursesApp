//
//  DownloadItemModel.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public struct DownloadItemModel: Hashable {
    public let id: Int32
    public let remoteVideoUrl: String
    public let localVideoUrl: String
    public let isDownloaded: Bool
    
    public init(id: Int32, remoteVideoUrl: String, localVideoUrl: String, isDownloaded: Bool) {
        self.id = id
        self.remoteVideoUrl = remoteVideoUrl
        self.localVideoUrl = localVideoUrl
        self.isDownloaded = isDownloaded
    }
}

