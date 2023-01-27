//
//  DownloadManager.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels
import AppDataBase
import Combine

class DownloadManager: NSObject {
    
    static let `default`: DownloadManager = DownloadManager()
    private let taskQueue = DispatchQueue(label: "DownloadManagerQueue", qos: .userInitiated)
    private var lessonsInQueue: [DownloadItemModel] = []
    let downloadCompleteSubject =  PassthroughSubject<Int32, Never>()
    let downloadProgressSubject = PassthroughSubject<(id:Int32,progress: Float), Never>()
    
    // MARK: - Controllers
    private let databaseControlelr: AppDatabase
    private let downloadService: DownloadService
    
    init(databaseControlelr: AppDatabase = AppDatabase.default, downloadService: DownloadService = DownloadService()) {
        self.databaseControlelr = databaseControlelr
        self.downloadService = downloadService
        super.init()
        self.downloadService.delegate = self
        fetchDownloadLessonQueue()
    }
   
    //MARK: - User action
    // start downlaod
    func download(lesson: LessonModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            // create new downlaod item
            let downloadLesson = DownloadItemModel(id: lesson.id,
                                                   remoteVideoUrl: lesson.videoUrl,
                                                   localVideoUrl: "",
                                                   isDownloaded: false)
            
            // save it to database
            self.addLessonInDatabase(lesson: downloadLesson)
            
            // start download it if there is no other lesson is downloadig
            self.startDownloadRequest()
        }
    }
    
    // cancel download and remove it from database
    func cancelDownloadFor(id: Int32) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            
            // Get downloaded item for the lesson
            guard let lesson = self.lessonsInQueue.filter({ $0.id == id }).first else {return}
            
            // Stop downloading the lesson if it is in progress
            self.downloadService.cancelDownloadFor(lesson: lesson)
            
            // removed downloaded lesson local file
            if let url = URL(string: lesson.localVideoUrl) {
                try? FileManager.default.removeItem(at: url)
            }
            
            // remove downlaoded lesson from database
            self.removeLessonFronDatabase(with: lesson)
            
        }
    }
    
    //MARK: - Handel Donwloading
    private func startDownloadRequest() {
        taskQueue.async { [weak self] in
            guard let self else {return}
            
            // check if the download service is ready for new download
            guard !self.downloadService.isDownloadInProgress() else {return}
            
            // get an lesson in the queue redy to be downloaded
            guard let item = self.lessonsInQueue.filter({ !$0.isDownloaded }).first else {return}
            
            //start new download
            self.downloadService.setupDownloadingSession(lesson: item)
        }
    }
    
    private func getDestinationUrlFor(lesson: DownloadItemModel) -> URL? {
        // get document path
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        guard let url = URL(string: lesson.remoteVideoUrl) else {return nil}
        return documentPath.appendingPathComponent(url.lastPathComponent)
    }
}

//MARK: - Database Functions
extension DownloadManager {
    //Fetch all downlaods items from database
    private func fetchDownloadLessonQueue() {
        taskQueue.async { [weak self] in
            guard let self else {return}
            self.lessonsInQueue = self.databaseControlelr.downloadRepository.getAll()
        }
    }
    
    //Update downloaded videos in database
    private func updateLessonInDatabase(lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.Update(item: lesson,
                                                              localUrl: lesson.localVideoUrl,
                                                              isDownloaded: true)
            self.fetchDownloadLessonQueue()
        }
    }
    
    // remove downlaoded lesson from database
    private func removeLessonFronDatabase(with lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.deleteItem(with: lesson.id)
            self.fetchDownloadLessonQueue()
        }
    }
    
    // add lesson to database
    private func addLessonInDatabase(lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.add(downloadItem: lesson)
            self.fetchDownloadLessonQueue()
        }
    }
}



//MARK: - DownloadServiceDelegate
extension DownloadManager: DownloadServiceDelegate {
    func didFinishDownloadFor(lesson: AppModels.DownloadItemModel?, location url: URL) {
        guard let lesson  else {return}
        taskQueue.async { [weak self] in
            guard let self else {return}
            
            // get new location for downlaoded lesson
            guard let destinationUrl = self.getDestinationUrlFor(lesson: lesson) else {return}
            print("destination url for : \(lesson.id)| location: \(destinationUrl)")
            
            // Clean this destination
            try? FileManager.default.removeItem(at: destinationUrl)
            
            do {
                // copy the lesson from the temporary location to permanent location
                try FileManager.default.copyItem(at: url, to: destinationUrl)
                let newLesson = DownloadItemModel(id: lesson.id,
                                                  remoteVideoUrl: lesson.remoteVideoUrl,
                                                  localVideoUrl: destinationUrl.absoluteString,
                                                  isDownloaded: true)
                // update the lesson in the database
                self.updateLessonInDatabase(lesson: newLesson)
                
                // update sendout lesseon downloa completed
                self.downloadCompleteSubject.send(lesson.id)
            } catch {
                print("Downlaod manager: Failed to copy file form \(url) to \(destinationUrl)")
            }
        }
    }
    
    func downloadProgressFor(lesson: AppModels.DownloadItemModel?, progress: Float) {
        guard let lesson  else {return}
        self.downloadProgressSubject.send((id: lesson.id, progress: progress))
    }
}
