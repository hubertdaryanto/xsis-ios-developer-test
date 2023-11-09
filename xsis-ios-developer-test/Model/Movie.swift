//
//  Movie.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let description: String?
    let poster_path: String?
    let release_date: String
    var poster_path_with_image_placeholder: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "overview"
        case poster_path = "poster_path"
        case release_date = "release_date"
        case poster_path_with_image_placeholder
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
