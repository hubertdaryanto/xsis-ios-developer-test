//
//  ConfigurationResponse.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

struct ConfigurationResponse: Codable {
    let images: Images
}

struct Images: Codable {
    let secure_base_url: String
}
