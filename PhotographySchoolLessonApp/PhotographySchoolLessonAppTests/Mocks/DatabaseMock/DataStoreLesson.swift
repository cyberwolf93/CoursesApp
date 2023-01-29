//
//  DataStoreLesson.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import AppModels
import Foundation

protocol DataStoreLesson {
    var lessons: [LessonModel] {get set}
}


class DataStoreLessonThreeItems: DataStoreLesson {
    var lessons: [LessonModel] = [
        LessonModel(id: 950,
                    name: "The Key To Success In iPhone Photography", lessonDescription: "The Key To Success In iPhone Photography",
                    thumbnailUrl: "",
                    videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"),
        LessonModel(id: 951,
                    name: "How To Choose The Correct iPhone Camera Lens", lessonDescription: "How To Choose The Correct iPhone Camera Lens",
                    thumbnailUrl: "",
                    videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/oazth83ovc.mp4"),
        LessonModel(id: 952,
                    name: "5 Unique Ways To Release The iPhone's Shutter", lessonDescription: "5 Unique Ways To Release The iPhone's Shutter",
                    thumbnailUrl: "",
                    videoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/4z5y6jgwxf.mp4")
    ]
}
