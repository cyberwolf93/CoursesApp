//
//  StringExtension.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 27/01/2023.
//

import Foundation


extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
