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
        
        // remove downloaded lessons from database with saved url without videos actually saved on the device
        self.cleanDirtyStoredLessons()
        // start download it if there is no other lesson is downloadig
        self.startDownloadRequest()
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
            
            // Fetch latest lessons from database
            self.fetchDownloadLessonQueue()
            
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
            self.removeLessonFromDatabase(with: lesson)
            
            // fetch last database lessons
            self.fetchDownloadLessonQueue()
            
            // Start the next video to be downloaded
            self.startDownloadRequest()
            
        }
    }
    
    // check if lesson in the download queue
    func isLessonInDonwloadQueue(id: Int32) -> Bool {
        var success = false
        let group = DispatchGroup()
        group.enter()
        taskQueue.async {[weak self] in
            guard let self else {
                group.leave()
                return
            }
            
            guard let _ = self.lessonsInQueue.filter({ $0.id == id }).first else {
                group.leave()
                return
            }
            
            success = true
            group.leave()
        }
        _ = group.wait(wallTimeout: .now() + 5)
        return success
    }
    
    
    // check if lesson download complete
    func isLessonDownloadComplete(id: Int32) -> Bool {
        var success = false
        let group = DispatchGroup()
        group.enter()
        taskQueue.async {[weak self] in
            guard let self else {
                group.leave()
                return
            }
            
            guard let lesson = self.lessonsInQueue.filter({ $0.id == id }).first else {
                group.leave()
                return
            }
            
            success = lesson.isDownloaded
            group.leave()
        }
        _ = group.wait(wallTimeout: .now() + 5)
        return success
    }
    
    // get lesson local downloaded url
    func getLessonLocalUrl(id: Int32) -> String {
        var url = ""
        let group = DispatchGroup()
        group.enter()
        taskQueue.async {[weak self] in
            guard let self else {
                group.leave()
                return
            }
            
            guard let lesson = self.lessonsInQueue.filter({ $0.id == id }).first else {
                group.leave()
                return
            }
            
            guard lesson.isDownloaded else {
                group.leave()
                return
            }
            
            url = lesson.localVideoUrl
            group.leave()
        }
        _ = group.wait(wallTimeout: .now() + 5)
        
        return url
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
    
    private func cleanDirtyStoredLessons() {
        taskQueue.async { [weak self] in
            guard let self else {return}
            let downloadedLessons = self.lessonsInQueue.filter({ $0.isDownloaded })
            
            downloadedLessons.forEach({ lesson in
                if let url = URL(string: lesson.localVideoUrl),
                   !FileManager.default.fileExists(atPath: url.path) {
                    self.removeLessonFromDatabase(with: lesson)
                }
            })
        }
    }
}

//MARK: - Database Functions
extension DownloadManager {
    //Fetch all downlaods items from database
    private func fetchDownloadLessonQueue() {
        taskQueue.async { [weak self] in
            guard let self else {return}
            self.lessonsInQueue = self.databaseControlelr.downloadRepository.getAll()
            print(self.lessonsInQueue.count)
        }
    }
    
    //Update downloaded videos in database
    private func updateLessonInDatabase(lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.Update(item: lesson,
                                                              localUrl: lesson.localVideoUrl,
                                                              isDownloaded: true)
        }
    }
    
    // remove downlaoded lesson from database
    private func removeLessonFromDatabase(with lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.deleteItem(with: lesson.id)
        }
    }
    
    // add lesson to database
    private func addLessonInDatabase(lesson: DownloadItemModel) {
        taskQueue.async {[weak self] in
            guard let self else {return}
            self.databaseControlelr.downloadRepository.add(downloadItem: lesson)
        }
    }
}



//MARK: - DownloadServiceDelegate
extension DownloadManager: DownloadServiceDelegate {
    func didFinishDownloadFor(lesson: AppModels.DownloadItemModel?, location url: URL) {
        guard let lesson  else {return}
        // get new location for downlaoded lesson
        guard let destinationUrl = self.getDestinationUrlFor(lesson: lesson) else {return}
        print("destination url for : \(lesson.id)| location: \(destinationUrl)")
        
        // Clean this destination
        try? FileManager.default.removeItem(at: destinationUrl)
        
        do {
            // copy the lesson from the temporary location to permanent location
            try FileManager.default.copyItem(at: url, to: destinationUrl)
            taskQueue.async { [weak self] in
                guard let self else {return}
                let newLesson = DownloadItemModel(id: lesson.id,
                                                  remoteVideoUrl: lesson.remoteVideoUrl,
                                                  localVideoUrl: destinationUrl.absoluteString,
                                                  isDownloaded: true)
                // update the lesson in the database
                self.updateLessonInDatabase(lesson: newLesson)
                
                // fetch last database lessons
                self.fetchDownloadLessonQueue()
                
                
                // update sendout lesseon downloa completed
                self.downloadCompleteSubject.send(lesson.id)
                
                // Start the next video to be downloaded
                self.startDownloadRequest()
            }
        } catch {
            print("Downlaod manager: Failed to copy file from \(url) to \(destinationUrl)")
        }
        
    }
    
    func downloadProgressFor(lesson: AppModels.DownloadItemModel?, progress: Float) {
        guard let lesson  else {return}
        self.downloadProgressSubject.send((id: lesson.id, progress: progress))
    }
}
