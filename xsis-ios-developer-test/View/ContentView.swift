//
//  ContentView.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showSearchView: Bool = false
    @State private var showContentDetailView: Bool = false
    @State private var movie_id_selected: Int? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    //MARK: BANNER
                    if let nowPlayingData = viewModel.nowPlayingResponse?.data {
                        TabView{
                            ForEach(nowPlayingData, id: \.id) { individualData in
                                HStack {
                                    if let configurationImageUrl = WebService.shared.configurationResponse?.images.secure_base_url, let poster_path = individualData.poster_path {
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
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(individualData.title)
                                        Text(individualData.description ?? "").lineLimit(5)
                                    }.padding(.trailing, 16)
                                }.onTapGesture {
                                    self.movie_id_selected = individualData.id
                                    self.showContentDetailView.toggle()
                                }
                            }.background(
                                RoundedRectangle(cornerRadius: 25).foregroundColor(.gray)
                            )
                        }.tabViewStyle(.page).frame(height: 300).padding(.all, 16)
                        
                    }
                    
                    //MARK: Top Rated LANDSCAPE COVER
                    if let topRatedData = viewModel.topRatedResponse?.data {
                        VStack(alignment: .leading) {
                            Text("Top Rated").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(topRatedData, id: \.id) { movie in
                                        
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
                                        ).onTapGesture {
                                            self.movie_id_selected = movie.id
                                            self.showContentDetailView.toggle()
                                        }
                                    }
                                }.frame(height: 180)
                                
                            }
                        }.padding(.all, 16)
                    }
                    
                    //MARK: Popular PORTRAIT COVER
                    if let popularData = viewModel.popularResponse?.data {
                        VStack(alignment: .leading) {
                            Text("Popular").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(popularData, id: \.id) { movie in
                                        
                                        
                                        VStack {
                                            Text(movie.title).frame(maxWidth: .infinity, alignment: .leading)
                                            if let configurationImageUrl = WebService.shared.configurationResponse?.images.secure_base_url, let poster_path = movie.poster_path {
                                                AsyncImage(url: URL(string: "\(configurationImageUrl)original\(poster_path)" )){ phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame( maxHeight: 210)
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
                                        }.padding(.all, 16).onTapGesture {
                                            self.movie_id_selected = movie.id
                                            self.showContentDetailView.toggle()
                                        }
                                    }.frame(width: 150).background(
                                        RoundedRectangle(cornerRadius: 25).foregroundStyle(.gray)
                                    )
                                }
                            }.frame(height: 180)
                            
                        }.padding(.all, 16)
                    }
                }
                
            }.sheet(isPresented: $showContentDetailView) {
                if let movie_id_selected = self.movie_id_selected, showContentDetailView {
                    ContentDetailView(showContentDetailView: $showContentDetailView, viewModel: ContentDetailViewModel(movie_id: movie_id_selected))
                }
            }.navigationDestination(isPresented: $showSearchView, destination: {
                ContentSearchView(showSearchView: $showSearchView)
            })
            .onAppear {
                viewModel.commonInit()
            }.navigationTitle("Netplix")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: {
                            self.showSearchView.toggle()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                        })
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
