//
//  ContentView.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import SwiftUI
import CoreData

struct LessonListView: View {
    @ObservedObject var viewModel: LessonListViewModel
    
    init(viewModel: LessonListViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().backgroundColor = .green
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List(viewModel.lessonList, id: \.self) { lesson in
                    ZStack { // this zstack to hide chevron icon in navigation link
                        HStack {
                            Spacer()
                            LessonListRow(viewModel: LessonListRowViewModel(lesson: lesson))
                                .frame(width: geometry.size.width * 0.9,  height: 80)
                            Spacer()
                        }
                        NavigationLink {
                            ListDetailsRepresentableView(lesson: lesson, nextLessons: viewModel.getNextLessonsAfter(lesson: lesson))
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                           EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowBackground(Color.clear)
                }
                .padding(0)
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("screen_title".localized())
            
        }
        .onAppear {
            viewModel.getLessons()
        }
        
    }
   
}


struct LessonListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonListView(viewModel: LessonListViewModel())
    }
}
