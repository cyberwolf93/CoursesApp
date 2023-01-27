//
//  DownloadService.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels

protocol DownloadServiceDelegate: NSObjectProtocol {
    func didFinishDownloadFor(lesson: DownloadItemModel?, location url: URL)
    func downloadProgressFor(lesson: DownloadItemModel?, progress: Float)
}
class DownloadService: NSObject {
    
    //MARK: - Variables
    var lesson: DownloadItemModel?
    var isDownlaoding: Bool = false
    var downloadTask: URLSessionDownloadTask?
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    weak var delegate: DownloadServiceDelegate?
    
    //MARK: - Methods
    func setupDownloadingSession(lesson: DownloadItemModel) {
        // Cancel if any task is running
        downloadTask?.cancel()
        downloadTask = nil
        
        //set the new lesson to be downloaded
        self.lesson = lesson
        
        // get the url or reset if url not valid
        guard let url = URL(string: lesson.remoteVideoUrl) else {
            self.lesson = nil
            return
        }
        // create new downlaod task
        downloadTask = downloadSession.downloadTask(with: url)
        self.startDownload()
    }
    
    func isDownloadInProgress() -> Bool {
        return isDownlaoding
    }
    
    func cancelDownloadFor(lesson: DownloadItemModel) {
        guard let currentLesson = self.lesson ,  currentLesson.id != lesson.id else {return}
        _ = self.stopDownload()
    }
    
    // MARK: - Internal methods
    private func stopDownload() -> DownloadItemModel? {
        defer {
            self.lesson = nil
        }
        downloadTask?.cancel()
        downloadTask = nil
        isDownlaoding = false
        return self.lesson
    }
    
    
    //MARK: private methods
    private func startDownload() {
        downloadTask?.resume()
        isDownlaoding = true
    }
    
    
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.delegate?.didFinishDownloadFor(lesson: self.lesson, location: location)
        _ = self.stopDownload()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.delegate?.downloadProgressFor(lesson: self.lesson, progress: progress)
    }
}
