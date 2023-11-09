//
//  WebService.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import Foundation
import Alamofire

final class WebService {
    
    static var shared: WebService = WebService()
    
    private var api_key = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNjFhN2IzMGNkNmUzOGYzYzlkNjcyZTkzNjAxZDJlYyIsInN1YiI6IjY1MDMwYTllZDdkY2QyMDExYzYxYWRhOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HLBlorjMDNBFPmJTn_Q93_TCfP1x5SZTJ_UdvXMVOc0"
    
    var configurationResponse: ConfigurationResponse? = nil
    
    func initializeConfiguration(completion: @escaping (_ success: Bool)->()){
        self.getConfiguration(complete: { (success, configuration) in
            switch success {
            case true:
                if let configuration = configuration {
                    self.configurationResponse = configuration
                    completion(true)
                }
            case false:
                completion(false)
                break
            }
        }
        )
    }
    
    func getConfiguration(complete: @escaping (_ success: Bool, _ data: ConfigurationResponse?)->()) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/configuration", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200..<600)
            .responseDecodable(of: ConfigurationResponse.self) { response in
                switch response.result {
                case .success(_):
                    guard response.value != nil else {
                        complete(false, nil)
                        return
                    }
                    complete(true, response.value!)
                case .failure(_):
                    guard response.data != nil else {
                        complete(false, nil)
                        return
                    }
                    let decoder = JSONDecoder()
                    if let JSON = try? decoder.decode(ConfigurationResponse.self, from: response.data!) {
                        complete(false, JSON)
                    }
                }
            }
    }
    
    func getListPopularMovie(complete: @escaping (_ success: Bool, _ data: PopularResponse?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/movie/popular?page=1&region=ID", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: PopularResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil)
                    return
                }
                complete(true, response.value!)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(PopularResponse.self, from: response.data!) {
                    complete(false, JSON)
                }
            }
        }
    }
    
    func getListTopRatedMovie(complete: @escaping (_ success: Bool, _ data: TopRatedResponse?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1&region=ID", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: TopRatedResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil)
                    return
                }
                complete(true, response.value!)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(TopRatedResponse.self, from: response.data!) {
                    complete(false, JSON)
                }
            }
        }
    }
    
    func getListNowPlayingMovie(complete: @escaping (_ success: Bool, _ data: NowPlayingForLandingPageBannerResponse?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: NowPlayingForLandingPageBannerResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil)
                    return
                }
                complete(true, response.value!)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(NowPlayingForLandingPageBannerResponse.self, from: response.data!) {
                    complete(false, JSON)
                }
            }
        }
    }
    
    func getSearchMovie(keyword: String, complete: @escaping (_ success: Bool, _ data: SearchResponse?, _ error: String?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/search/movie?query=\(keyword)&page=1&region=ID", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil, response.error?.localizedDescription)
                    return
                }
                complete(true, response.value!, nil)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil, response.error?.localizedDescription)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(SearchResponse.self, from: response.data!) {
                    complete(false, JSON, response.error?.localizedDescription)
                }
            }
        }
    }
    
    func getDetailMovie(id: Int, complete: @escaping (_ success: Bool, _ data: MovieDetailResponse?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/movie/\(id)?language=en-US", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil)
                    return
                }
                complete(true, response.value!)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(MovieDetailResponse.self, from: response.data!) {
                    complete(false, JSON)
                }
            }
        }
    }
    
    func getListMovieSimilar(id: Int, complete: @escaping (_ success: Bool, _ data: MovieSimilarResponse?)->()){
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(api_key)"
        ]
        
        AF.request("https://api.themoviedb.org/3/movie/\(id)/similar?language=en-US&page=1", method: .get, parameters: nil, headers: headers)
        .validate(statusCode: 200..<600)
        .responseDecodable(of: MovieSimilarResponse.self) { response in
            switch response.result {
            case .success(_):
                guard response.value != nil else {
                    complete(false, nil)
                    return
                }
                complete(true, response.value!)
            case .failure(_):
                guard response.data != nil else {
                    complete(false, nil)
                    return
                }
                let decoder = JSONDecoder()
                if let JSON = try? decoder.decode(MovieSimilarResponse.self, from: response.data!) {
                    complete(false, JSON)
                }
            }
        }
    }
}
