//
//  ContentSearchView.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import SwiftUI

struct ContentSearchView: View {
    @StateObject private var viewModel: ContentSearchViewModel = ContentSearchViewModel()
    @Binding var showSearchView: Bool
    @State private var showContentDetailView: Bool = false
    @State private var movie_id_selected: Int? = nil
    private let throttler = Throttler(minimumDelay: 0.5)
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: (UIScreen.main.bounds.width - 32) / 2)), count: 2)
    }
    var body: some View {
        VStack {
            SearchBar(searchLabel: "Search Movie", text: $viewModel.searchText).frame(alignment: .top)
            VStack {
                if let searchData = viewModel.searchResponse?.data {
                    ScrollView {
                        VStack {
                            LazyVGrid(columns: items, content: {
                                ForEach(searchData, id: \.id) { movie in
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
                                    }.padding(.all, 16).frame(width: 150).background(
                                        RoundedRectangle(cornerRadius: 25).foregroundStyle(.gray)
                                    ).onTapGesture {
                                        self.movie_id_selected = movie.id
                                        self.showContentDetailView.toggle()
                                    }
                                }
                            })
                        }
                    }
                }
            }.frame(maxHeight: .infinity)
            
        }.sheet(isPresented: $showContentDetailView) {
            if let movie_id_selected = self.movie_id_selected, showContentDetailView {
                ContentDetailView(showContentDetailView: $showContentDetailView, viewModel: ContentDetailViewModel(movie_id: movie_id_selected))
            }
        }.onChange(of: viewModel.searchText) {
            //MARK: Pakai throttler biar tidak berat
            throttler.throttle {
                viewModel.fetchSearchResult()                
            }
        }
    }
}

#Preview {
    ContentSearchView(showSearchView: .constant(true))
}
