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

class LessonListViewModel: ObservableObject {
    
    @Published var lessonList: [LessonModel] = []
    private var cancellable: [AnyCancellable] = []
    
    func getLessons() {
        ClienApiController.default.lessonNetworkManager.fetchLessons()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion, let error = error as? NetworkEngineError {
                    print(error)
                }
            } receiveValue: { [weak self] lessons in
                self?.lessonList = lessons
            }.store(in: &self.cancellable)
    }
}
