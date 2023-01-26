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
    
    @nonobjc public class func deleteRequestWith(predicate: NSPredicate) -> NSBatchDeleteRequest {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = DownloadItem.fetchRequest()
        fetchRequest.predicate = predicate
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    @NSManaged public var id: Int32
    @NSManaged public var remoteVideoUrl: String?
    @NSManaged public var localVideoUrl: String?
    @NSManaged public var isDownloaded: Bool

}
