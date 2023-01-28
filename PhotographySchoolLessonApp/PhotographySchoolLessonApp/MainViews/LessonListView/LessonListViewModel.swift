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
    
    private func getLessonsLocal() {
        lessonList = self.appDatabase.lessonRepository.getAll()
    }
    
    private func getLessonsRemote() {
        ClienApiController.default.lessonNetworkManager.fetchLessons()
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
