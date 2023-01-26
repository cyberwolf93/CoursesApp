//
//  DownloadItemModel.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

public struct DownloadItemModel {
    let id: Int32
    let remoteVideoUrl: String
    let localVideoUrl: String
    let isDownloaded: Bool
}
