//
//  LessonListViewModelMock.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
@testable import PhotographySchoolLessonApp

class LessonListViewModelMock: LessonListViewModel {
    
    var deviceIsConectedToInternet = false
    
    override func isInternetConnectionExist() -> Bool {
        return deviceIsConectedToInternet
    }
}
