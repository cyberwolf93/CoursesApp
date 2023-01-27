//
//  DownloadRepository.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels

public class DownloadRepository {
    
    private let controller: DownloadDataController
    init(controller: DownloadDataController) {
        self.controller = controller
    }
    
    //MARK: - Fetching data
    public func getAll() -> [DownloadItemModel] {
        var downloadItems = [DownloadItemModel]()
        let downloadItemsDB = controller.getAll()
        downloadItemsDB.forEach { downloadItems.append(DownloadItem.convertFrom(downloadItemDB: $0)) }
        return downloadItems
    }
    
    public func get(with id: Int32) -> DownloadItemModel? {
        guard let downloadItemDB = controller.get(with: id) else {
            return nil
        }
        
        return DownloadItem.convertFrom(downloadItemDB: downloadItemDB)
    }
    
    public func getAllDownloadedItem() -> [DownloadItemModel] {
        var downloadItems = [DownloadItemModel]()
        let downloadItemsDB = controller.getAllDownloadedItem()
        downloadItemsDB.forEach { downloadItems.append(DownloadItem.convertFrom(downloadItemDB: $0)) }
        return downloadItems
    }
    
    //MARK: - Add data
    public func add(downloadItem: DownloadItemModel) {
        guard controller.get(with: downloadItem.id) == nil else {
            return
        }
        controller.add(downloadItem: downloadItem)
    }
    
    public func add(downloadItems: [DownloadItemModel]) {
        downloadItems.forEach{self.add(downloadItem: $0)}
    }
    
    //MARK: - Update data
    public func Update(item: DownloadItemModel, localUrl: String, isDownloaded: Bool) {
        guard let itemDB = controller.get(with: item.id) else {
            return
        }
        controller.Update(item: itemDB, localUrl: localUrl, isDownloaded: isDownloaded)
    }
    
    
    //MARK: - Delete Data
    public func deleteItem(with id: Int32) {
        controller.deleteItem(with: id)
    }
}
