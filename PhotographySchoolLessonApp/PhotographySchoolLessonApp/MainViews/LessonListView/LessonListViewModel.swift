//
//  LessonListViewModel.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation
import AppModels
import Combine
import ClientAPI
import AppDataBase
import Reachability


class LessonListViewModel: ObservableObject {
    
    @Published var lessonList: [LessonModel] = []
    private var cancellable: [AnyCancellable] = []
    var appDatabase: AppDatabase = AppDatabase.default
    var clientApi: ClienApiController = ClienApiController.default
    
    // MARK: - Handling data
    func isInternetConnectionExist() -> Bool {
        guard let reachability = try? Reachability() else {return false}
        switch (reachability.connection) {
        case .unavailable, .none:
            return false
        default:
            return true
        }
    }
    
    func getLessons() {
        if ProcessInfo.processInfo.arguments.contains("-UITestLaunch") {
            getLessonsStatically()
            return
        }
        
        if self.isInternetConnectionExist() {
            self.getLessonsRemote()
            return
        }
        
        self.getLessonsLocal() 
    }
    
    //MARK: - View helper methods
    func getNextLessonsAfter(lesson: LessonModel) -> [LessonModel] {
        var lessonIndex = -1
        var nextLessonsList = [LessonModel]()
        // Get the lessons index
        for (i,lessonFromList) in  lessonList.enumerated() {
            if lesson.id == lessonFromList.id {
                lessonIndex = i
                break
            }
        }
        
        var lastIndex = lessonList.count - 1
        // return next lessons list as a stack so the next lesson will be on the top of the stack
        // and the last lesson will be at the bottom of the stack
        while(lessonIndex >= 0 && lastIndex > lessonIndex) {
            nextLessonsList.append(lessonList[lastIndex])
            lastIndex -= 1
        }
        return nextLessonsList
    }
    
    // MARK: - Internal methods
    private func getLessonsLocal() {
        lessonList = self.appDatabase.lessonRepository.getAll()
    }
    
    private func getLessonsRemote() {
        clientApi.lessonNetworkManager.fetchLessons()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion, let error = error as? NetworkEngineError {
                    print(error)
                }
            } receiveValue: { [weak self] lessons in
                self?.lessonList = lessons
                self?.appDatabase.lessonRepository.add(lessons: lessons)
            }.store(in: &self.cancellable)
    }
}


//MARK: - Set static data for testing
extension LessonListViewModel {
    private func getLessonsStatically() {
        let lessons = [
            LessonModel(id: 950,
                        name: "The Key To Success In iPhone Photography",
                        lessonDescription: "What\\u2019s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there\\u2019s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!",
                        thumbnailUrl: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
                        videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"),
            LessonModel(id: 7991,
                        name: "How To Choose The Correct iPhone Camera Lens",
                        lessonDescription: "If your iPhone has more than one lens, how do you choose which lens to use? And which lens is best for different photography genres? It turns out that you'll get dramatically different results depending on which lens you use. Watch this video from our breakthrough iPhone Photo Academy course and discover how to choose the correct iPhone camera lens.",
                        thumbnailUrl: "https://embed-ssl.wistia.com/deliveries/f7105de283304e0dc6fe40e5abbf778f.jpg?image_crop_resized=1000x560",
                        videoUrl: "https://embed-ssl.wistia.com/deliveries/db6cd74cf31ff8afca1f71b3c12fd820dcbde404/oazth83ovc.mp4"),
            LessonModel(id: 1486,
                        name: "5 Unique Ways To Release The iPhone's Shutter",
                        lessonDescription: "Most people only use one way to release the shutter button of your iPhone. But it's not always the best way to achieve great photo results. Watch this video and discover 5 unique ways to release the shutter button of your iPhone. Each way will be very useful for a different photography scenario so you can always take the best photos possible.",
                        thumbnailUrl: "https://embed-ssl.wistia.com/deliveries/e5c2455db46b9303be35dac404b65783.jpg?image_crop_resized=1000x560",
                        videoUrl: "https://embed-ssl.wistia.com/deliveries/f6f1d8e03b872e68ef9a01f6a02e56ee44f2a779/4z5y6jgwxf.mp4")
        ]
        
        lessonList = lessons
    }
}
