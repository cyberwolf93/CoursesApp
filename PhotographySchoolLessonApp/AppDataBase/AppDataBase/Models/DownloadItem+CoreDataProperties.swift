//
//  DownloadItem+CoreDataProperties.swift
//  
//
//  Created by Ahmed Mohiy on 26/01/2023.
//
//

import Foundation
import CoreData


extension DownloadItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadItem> {
        return NSFetchRequest<DownloadItem>(entityName: "DownloadItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var remoteVideoUrl: String?
    @NSManaged public var localVideoUrl: String?
    @NSManaged public var isDownloaded: Bool

}
