//
//  DownloadItem+CoreDataClass.swift
//  
//
//  Created by Ahmed Mohiy on 26/01/2023.
//
//

import Foundation
import CoreData
import AppModels

public class DownloadItem: NSManagedObject {

}

//MARK: - Convert from CoreData lessonObject
extension  DownloadItem {
    static func convertFrom(downloadItemDB: DownloadItem) -> DownloadItemModel {
        return DownloadItemModel(id: downloadItemDB.id,
                                 remoteVideoUrl: downloadItemDB.remoteVideoUrl ?? "",
                                 localVideoUrl: downloadItemDB.localVideoUrl ?? "",
                                 isDownloaded: downloadItemDB.isDownloaded)
    }
}
