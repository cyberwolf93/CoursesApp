//
//  PlayerViewControllerViewModel.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels
import AVKit

class PlayerViewControllerViewModel {
    
    let lesson: LessonModel
    let downloadManager: DownloadManager
    
    init(lesson: LessonModel, downloadManager: DownloadManager = DownloadManager()) {
        self.lesson = lesson
        self.downloadManager = downloadManager
    }
    
    func getAvPlayer() -> AVPlayer? {
        // play locally
        if let url = URL(string: downloadManager.getLessonLocalUrl(id: lesson.id)) {
            let newUrl = URL(fileURLWithPath: url.path)
            return AVPlayer(url: newUrl)
        }
        
        // pLay remotly
        guard let url = URL(string: lesson.videoUrl) else {
            return nil
        }
        
        return AVPlayer(url: url)
        
    }
}
