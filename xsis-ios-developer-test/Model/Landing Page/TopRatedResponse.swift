//
//  TopRatedResponse.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

struct TopRatedResponse: Decodable {
    let data: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case data = "results"
    }
}
