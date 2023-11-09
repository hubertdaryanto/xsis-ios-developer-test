//
//  ContentDetailView.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import SwiftUI

struct ContentDetailView: View {
    @Binding var showContentDetailView: Bool
    @StateObject var viewModel: ContentDetailViewModel
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "xmark.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 24, height: 24).onTapGesture {
                    self.showContentDetailView.toggle()
                }
            }
            ScrollView{
                //MARK: Dummy youtube trailer, tmdb API doesn't provide video
                if let wkWebView = viewModel.wkWebView {
                    ContentDetailWebView(wkWebView: wkWebView).frame(height: 300)
                }
                Text(viewModel.movieDetailResponse?.title ?? "").frame(maxWidth: .infinity, alignment: .leading).font(.title)
                Text(viewModel.movieDetailResponse?.description ?? "").padding(.bottom, 32)
                if let listMovieSimilar = viewModel.movieSimilarResponse?.data {
                    VStack(alignment: .leading) {
                        Text("Similar").bold().frame(maxWidth: .infinity, alignment: .leading)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(listMovieSimilar, id: \.id) { movie in
                                    
                                    VStack {
                                        if let configurationImageUrl = WebService.shared.configurationResponse?.images.secure_base_url, let poster_path = movie.poster_path {
                                            AsyncImage(url: URL(string: "\(configurationImageUrl)original\(poster_path)" )){ phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame( maxHeight: 210).padding(.all, 16)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                @unknown default:
                                                    // Since the AsyncImagePhase enum isn't frozen,
                                                    // we need to add this currently unused fallback
                                                    // to handle any new cases that might be added
                                                    // in the future:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                        Text(movie.title).padding(.bottom, 16)
                                    }.frame(width: 220).background(
                                        RoundedRectangle(cornerRadius: 25).foregroundStyle(.gray)
                                    )
                                }
                            }.frame(height: 180)
                            
                        }
                    }.frame(maxWidth: .infinity)
                }
                
            }
        }.padding(.all, 16).onAppear {
            viewModel.fetchMovieDetail()
        }
        
    }
}

#Preview {
    ContentDetailView(showContentDetailView: .constant(true), viewModel: ContentDetailViewModel(movie_id: 507089))
}
