//
//  MovieDetailResponse.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let title: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description = "overview"
    }
}
