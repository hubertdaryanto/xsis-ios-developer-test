//
//  ContentDetailViewModel.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation
import WebKit

final class ContentDetailViewModel: NSObject, ObservableObject {
    @Published var movieDetailResponse: MovieDetailResponse? = nil
    @Published var movieSimilarResponse: MovieSimilarResponse? = nil
    @Published var wkWebView: WKWebView? = nil
    private var movie_id: Int
    
    init(movie_id: Int){
        self.movie_id = movie_id
    }
    
    func fetchMovieDetail() {
        WebService.shared.getDetailMovie(id: movie_id, complete: { (success, movieDetailResponse) in
            switch success {
            case true:
                if let movieDetailResponse = movieDetailResponse {
                    self.movieDetailResponse = movieDetailResponse
                }
                self.prepareDummyWebView()
            case false:
                break
            }
        })
    }
    
    private func prepareDummyWebView(){
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let controller = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = controller
        configuration.allowsInlineMediaPlayback = true
        wkWebView = WKWebView(frame: .zero, configuration: configuration)
        wkWebView?.uiDelegate = self
        guard let wkWebView = wkWebView else { return }
        let urlString = "https://youtu.be/oyRxxpD3yNw?si=6G5nqp9gfMWqwQ3r"
        let request = URLRequest(url: URL(string: urlString)!)
        wkWebView.load(request)
        self.fetchMovieSimilar()
    }
    
    private func fetchMovieSimilar() {
        WebService.shared.getListMovieSimilar(id: movie_id, complete: { (success, movieSimilarResponse) in
            switch success {
            case true:
                if let movieSimilarResponse = movieSimilarResponse {
                    self.movieSimilarResponse = movieSimilarResponse
                }
            case false:
                break
            }
        })
    }
}

extension ContentDetailViewModel: WKUIDelegate{
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
           if !(navigationAction.targetFrame?.isMainFrame ?? false) {
               webView.load(navigationAction.request)
           }
           return nil
       }
}
