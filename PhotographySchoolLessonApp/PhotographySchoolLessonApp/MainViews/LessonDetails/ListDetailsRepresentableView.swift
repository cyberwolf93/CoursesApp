//
//  ListDetailsRepresentableView.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import SwiftUI
import AppModels

struct ListDetailsRepresentableView: UIViewControllerRepresentable {
    
    var lesson: LessonModel
    
    func makeUIViewController(context: Context) -> ListDetailsViewController {
        let viewController = ListDetailsViewController()
        viewController.viewModel = ListDetailsViewModel(lesson: lesson)
        
        context.coordinator.parentObserver = viewController.observe(\.parent, changeHandler: { vc, _ in
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        context.coordinator.rightBarButtonItemsObserver = viewController.observe(\.navigationItem.rightBarButtonItems, changeHandler: { vc, _ in
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ListDetailsViewController, context: Context) {
    }
    
    func makeCoordinator() -> Self.Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var parentObserver: NSKeyValueObservation?
        var rightBarButtonItemsObserver: NSKeyValueObservation?
    }
    
}
