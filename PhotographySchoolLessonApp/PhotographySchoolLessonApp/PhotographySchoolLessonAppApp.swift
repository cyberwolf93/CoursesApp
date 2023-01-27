//
//  PhotographySchoolLessonAppApp.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import SwiftUI

@main
struct PhotographySchoolLessonAppApp: App {

    var body: some Scene {
        WindowGroup {
            LessonListView(viewModel: LessonListViewModel())
        }
    }
}
