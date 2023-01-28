//
//  DownloadService.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import UIKit
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
    var serialQueue = DispatchQueue(label: "DownloadServiceQueue", qos: .userInitiated)
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    weak var delegate: DownloadServiceDelegate?
    
    //MARK: - Methods
    func setupDownloadingSession(lesson: DownloadItemModel) {
        serialQueue.async {[weak self] in
            // Cancel if any task is running
            self?.downloadTask?.cancel()
            self?.downloadTask = nil
            
            //set the new lesson to be downloaded
            self?.lesson = lesson
            
            // get the url or reset if url not valid
            guard let url = URL(string: lesson.remoteVideoUrl) else {
                self?.lesson = nil
                return
            }
            // create new downlaod task
            self?.downloadTask = self?.downloadSession.downloadTask(with: url)
            self?.startDownload()
        }
    }
    
    func isDownloadInProgress() -> Bool {
        var downlaoding = false
        let group = DispatchGroup()
        group.enter()
        serialQueue.async {[weak self] in
            downlaoding = self?.isDownlaoding ?? true
            group.leave()
        }
        _ = group.wait(wallTimeout: .now() + 5)
        return downlaoding
    }
    
    func cancelDownloadFor(lesson: DownloadItemModel) {
        guard let currentLesson = self.lesson , currentLesson.id == lesson.id else {return}
        self.stopDownload()
    }
    
    // MARK: - Internal methods
    private func stopDownload() {
        serialQueue.async {[weak self] in
            defer {
                self?.lesson = nil
            }
            self?.downloadTask?.cancel()
            self?.downloadTask = nil
            self?.isDownlaoding = false
        }
        
    }
    
    
    //MARK: private methods
    private func startDownload() {
        serialQueue.async {[weak self] in
            self?.downloadTask?.resume()
            self?.isDownlaoding = true
        }
        
    }
    
    
}

extension DownloadService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.delegate?.didFinishDownloadFor(lesson: self.lesson, location: location)
        print("DownloadService: lesson complete \(self.lesson?.id) | location: \(location)")
        self.stopDownload()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        self.delegate?.downloadProgressFor(lesson: self.lesson, progress: progress)
        print("DownloadService: lesson progress id:  \(self.lesson?.id) | progress: \(progress)")
    }
    
}
