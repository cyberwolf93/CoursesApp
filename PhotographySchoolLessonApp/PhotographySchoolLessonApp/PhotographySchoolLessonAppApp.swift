//
//  PhotographySchoolLessonAppApp.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import SwiftUI
import AVFoundation
import AppDataBase

@main
struct PhotographySchoolLessonAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LessonListView(viewModel: LessonListViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true)
        } catch {
            print("Failed to activate audio session in background")
        }
        
        // Check if the app started from UI test case
        if ProcessInfo.processInfo.arguments.contains("-UITestLaunch") {
            let allDownloadedItems = AppDatabase.default.downloadRepository.getAll()
            allDownloadedItems.forEach({AppDatabase.default.downloadRepository.deleteItem(with: $0.id) })
        }
        
        // This line to trigger download manager and start downloading the pending lessons
        _ = DownloadManager.default
        
        return true
    }
}
