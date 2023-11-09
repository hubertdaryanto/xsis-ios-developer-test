//
//  ContentViewModel.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var popularResponse: PopularResponse? = nil
    @Published var topRatedResponse: TopRatedResponse? = nil
    @Published var nowPlayingResponse: NowPlayingForLandingPageBannerResponse? = nil
    
    func commonInit() {
        WebService.shared.initializeConfiguration(completion: { success in
            switch success {
            case true:
                self.fetchNowPlayingForBanner()
            case false:
                print("get configuration error")
            }
        })
    }
    
    private func fetchNowPlayingForBanner() {
        WebService.shared.getListNowPlayingMovie(complete: { (success, nowPlayingResponse) in
            switch success {
            case true:
                if let nowPlayingResponse = nowPlayingResponse {
                    self.nowPlayingResponse = nowPlayingResponse
                }
                self.fetchTopRated()
            case false:
                break
            }
        })
    }
    
    private func fetchTopRated() {
        WebService.shared.getListTopRatedMovie(complete: { (success, topRatedResponse) in
            switch success {
            case true:
                if let topRatedResponse = topRatedResponse {
                    self.topRatedResponse = topRatedResponse
                }
                self.fetchPopularMovie()
            case false:
                break
            }
        })
    }
    
    private func fetchPopularMovie() {
        WebService.shared.getListPopularMovie(complete: { (success, popularResponse) in
            switch success {
            case true:
                if let popularResponse = popularResponse {
                    self.popularResponse = popularResponse
                }
            case false:
                break
            }
        })
    }
}
