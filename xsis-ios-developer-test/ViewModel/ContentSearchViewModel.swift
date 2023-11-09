//
//  ContentSearchViewModel.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

final class ContentSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResponse: SearchResponse? = nil
    
    func fetchSearchResult(){
        self.searchResponse = nil
        WebService().getSearchMovie(keyword: searchText) { (success, searchResponse, error) in
            switch success {
            case true:
                if let searchResponse = searchResponse {
                    self.searchResponse = searchResponse
                }
            case false:
                break
            }
        }
    }
}
