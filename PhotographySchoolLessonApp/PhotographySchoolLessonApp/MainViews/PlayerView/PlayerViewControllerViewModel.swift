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
    
    init(lesson: LessonModel) {
        self.lesson = lesson
    }
    
    func getAvPlayer() -> AVPlayer? {
        guard let url = URL(string: lesson.videoUrl) else {
            return nil
        }
        
        return AVPlayer(url: url)
    }
}
