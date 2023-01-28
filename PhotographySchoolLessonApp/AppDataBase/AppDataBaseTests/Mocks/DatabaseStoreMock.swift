//
//  DatabaseStoreMock.swift
//  AppDataBaseTests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

import AppModels
@testable import AppDataBase
import Foundation

class DatabaseStoreMock {
    let appDatabaseManager: AppDatabaseManagerMock
    
    lazy var lessons: [Lesson] =  {
        var lesson = Lesson(context: appDatabaseManager.persistentContainer.viewContext)
        lesson.id = 950
        lesson.name =  "The Key To Success In iPhone Photography"
        lesson.lessonDescription = "What\\u2019s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there\\u2019s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!"
        lesson.thumbnailUrl =  "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560"
        lesson.videoUrl =  "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        return [lesson]
    }()
    lazy var downloaditems: [DownloadItem] = {
        var item1 = DownloadItem(context: appDatabaseManager.persistentContainer.viewContext)
        item1.id = 950
        item1.remoteVideoUrl = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        item1.localVideoUrl =  "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        item1.isDownloaded = false
        
        var item2 = DownloadItem(context: appDatabaseManager.persistentContainer.viewContext)
        item2.id = 951
        item2.remoteVideoUrl = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        item2.localVideoUrl =  "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        item2.isDownloaded = true
        
        
        return [item1, item2]
    }()
    
    init(appDatabaseManager: AppDatabaseManagerMock) {
        self.appDatabaseManager = appDatabaseManager
        
    }
    
    
}
