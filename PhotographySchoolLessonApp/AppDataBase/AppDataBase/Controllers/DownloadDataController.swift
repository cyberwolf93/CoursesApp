//
//  DownloadDataContainer.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation

class DownloadDataController {
    
    let databaseManager: AppDatabaseManager
    
    init(databaseManager: AppDatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    //MARK: - Fetching data
    func getAll() -> [DownloadItem] {
        do {
            return try databaseManager.persistentContainer.viewContext.fetch(DownloadItem.fetchRequest())
        } catch {
            print("Failed to fetch all download items error: \(error)")
            return []
        }
    }
    
    func get(with id: Int32) -> DownloadItem? {
        do {
            let fetchRequest = DownloadItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            return try databaseManager.persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch downloaded item: \(id) error: \(error)")
            return nil
        }
    }
    
    func getAllDownloadedItem() -> [DownloadItem] {
        do {
            let fetchRequest = DownloadItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isDownloaded = %@", true)
            return try databaseManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch downloaded items error: \(error)")
            return []
        }
    }
    
    //MARK: - Add data
    func add(downloadItem: DownloadItemModel) {
        let newItem = DownloadItem(context: databaseManager.persistentContainer.viewContext)
        newItem.id = downloadItem.id
        newItem.remoteVideoUrl = downloadItem.remoteVideoUrl
        newItem.localVideoUrl = downloadItem.localVideoUrl
        newItem.isDownloaded = downloadItem.isDownloaded
        
        
        do {
            try databaseManager.persistentContainer.viewContext.save()
        } catch {
            print("Failed to add download item \(downloadItem.id) error: \(error)")
        }
    }
    
    //MARK: - Update data
    func Update(item: DownloadItem, localUrl: String, isDownloaded: Bool) {
        item.localVideoUrl = localUrl
        item.isDownloaded = isDownloaded
        do {
            try databaseManager.persistentContainer.viewContext.save()
        } catch {
            print("Failed to update item \(item.id) error: \(error)")
        }
    }
    
    
    //MARK: - Delete Data
    func deleteItem(with id: Int32) {
        let predicate = NSPredicate(format: "id = %@", id)
        let deleteRequest = DownloadItem.deleteRequestWith(predicate: predicate)
        do {
            try databaseManager.persistentContainer.viewContext.execute(deleteRequest)
            try databaseManager.persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete all lessons error: \(error)")
        }
    }
    
}
