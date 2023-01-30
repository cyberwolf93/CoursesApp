//
//  AccessabitlityIDType.swift
//  PhotographySchoolLessonApp
//
//  Created by Ahmed Mohiy on 30/01/2023.
//

import Foundation

enum ListAccessibilityIDType: String {
    case cellTitle = "list_cell_title"
}

enum DetailsAccessibilityIDType: String {
    case playButton = "details_play_button"
    case title = "details_title"
    case description = "details_description"
    case downlaodButton = "details_download_button"
    case nextLessonButton = "details_next_button"
    case downloadViewSeparator = "details_download_view_separator"
    case downloadLabel = "details_download_label"
    case downloadProgressView = "details_download_progress_view"
}

enum PlayerAccessibilityIDType: String {
    case parentView = "player_parent_view"
}
