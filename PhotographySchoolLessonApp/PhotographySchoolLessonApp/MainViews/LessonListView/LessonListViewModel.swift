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
