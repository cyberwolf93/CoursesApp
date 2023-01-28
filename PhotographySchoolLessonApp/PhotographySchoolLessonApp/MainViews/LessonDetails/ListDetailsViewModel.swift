//
//  ListDetailsViewModel.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels
import Combine

class ListDetailsViewModel {
    
    let lesson: LessonModel
    let nextLessons: [LessonModel]
    let downloadManager: DownloadManager
    private var cancelable = Set<AnyCancellable>()
    
    let downloadCompleteSubject =  PassthroughSubject<String, Never>()
    let downloadProgressSubject = PassthroughSubject<Float, Never>()
    
    
    init(lesson: LessonModel,nextLessons: [LessonModel], downloadManager: DownloadManager = DownloadManager.default) {
        self.lesson = lesson
        self.nextLessons = nextLessons
        self.downloadManager = downloadManager
        self.listenForDownloadComplete()
        self.listenForDownloadProgress()
    }
    
    //MARK: - Next lesson helper methods
    func getNextLesson() -> LessonModel? {
        return nextLessons.last
    }
    
    func prepareNextLessonList() -> [LessonModel] {
        var nextLessonList = nextLessons
        nextLessonList.removeLast()
        return nextLessonList
    }
    
    // MARK: - Download Helper methods
    func checkLessonInDownloadQueue() -> Bool {
        return self.downloadManager.isLessonInDonwloadQueue(id: lesson.id)
    }
    
    func checkLessonDownloadComplete() -> Bool {
        return self.downloadManager.isLessonDownloadComplete(id: lesson.id)
    }
    
    func listenForDownloadComplete() {
        self.downloadManager.downloadCompleteSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self else {return}
                if id == self.lesson.id {
                    self.downloadCompleteSubject.send("")
                }
            }.store(in: &cancelable)
    }
    
    func listenForDownloadProgress() {
        self.downloadManager.downloadProgressSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else {return}
                if result.id == self.lesson.id {
                    self.downloadProgressSubject.send(result.progress)
                }
            })
            .store(in: &cancelable)
    }
    
    
    func startDownload() {
        self.downloadManager.download(lesson: lesson)
    }
    
    func removeDownload() {
        self.downloadManager.cancelDownloadFor(id: lesson.id)
    }
}
