//
//  DownloadRepository.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation

public class DownloadRepository {
    
    private let controller: DownloadDataController
    init(controller: DownloadDataController) {
        self.controller = controller
    }
    
    //MARK: - Fetching data
    func getAll() -> [DownloadItemModel] {
        var downloadItems = [DownloadItemModel]()
        let downloadItemsDB = controller.getAll()
        downloadItemsDB.forEach { downloadItems.append(DownloadItemModel.convertFrom(downloadItemDB: $0)) }
        return downloadItems
    }
    
    func get(with id: Int32) -> DownloadItemModel? {
        guard let downloadItemDB = controller.get(with: id) else {
            return nil
        }
        
        return DownloadItemModel.convertFrom(downloadItemDB: downloadItemDB)
    }
    
    func getAllDownloadedItem() -> [DownloadItemModel] {
        var downloadItems = [DownloadItemModel]()
        let downloadItemsDB = controller.getAllDownloadedItem()
        downloadItemsDB.forEach { downloadItems.append(DownloadItemModel.convertFrom(downloadItemDB: $0)) }
        return downloadItems
    }
    
    //MARK: - Add data
    func add(downloadItem: DownloadItemModel) {
        guard controller.get(with: downloadItem.id) == nil else {
            return
        }
        controller.add(downloadItem: downloadItem)
    }
    
    func add(downloadItems: [DownloadItemModel]) {
        downloadItems.forEach{self.add(downloadItem: $0)}
    }
    
    //MARK: - Update data
    func Update(item: DownloadItemModel, localUrl: String, isDownloaded: Bool) {
        guard let itemDB = controller.get(with: item.id) else {
            return
        }
        controller.Update(item: itemDB, localUrl: localUrl, isDownloaded: isDownloaded)
    }
    
    
    //MARK: - Delete Data
    func deleteItem(with id: Int32) {
        controller.deleteItem(with: id)
    }
}
