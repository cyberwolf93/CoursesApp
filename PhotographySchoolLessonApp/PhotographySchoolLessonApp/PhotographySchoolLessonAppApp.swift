//
//  PhotographySchoolLessonAppApp.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import SwiftUI

@main
struct PhotographySchoolLessonAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
