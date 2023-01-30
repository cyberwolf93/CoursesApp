//
//  LessonListRow.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import AppModels

struct LessonListRow: View {
    let viewModel: LessonListRowViewModel
    var body: some View {
        GeometryReader { geometry in
            HStack {
                WebImage(url: URL(string: viewModel.lesson.thumbnailUrl))
                    .resizable()
                    .frame(width: geometry.size.width  * 0.4, height: (geometry.size.width  * 0.4) * 9 / 16 )
                    .cornerRadius(5)
                    .padding(.trailing, 5)
                
                Text(viewModel.lesson.name)
                    .font(.body)
                    .lineLimit(3)
                    .accessibilityIdentifier(ListAccessibilityIDType.cellTitle.rawValue)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.blue)
                }
                
            }
            
        }
    }
}


struct LessonListRow_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
            LessonListRow(viewModel: LessonListRowViewModel(lesson: LessonModel(id: 12,
                                                          name: "Name",
                                                          lessonDescription: "descriptt",
                                                          thumbnailUrl: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
                                                          videoUrl: "")))
//        }.previewLayout(.fixed(width: 400, height: 100))
        
    }
}
