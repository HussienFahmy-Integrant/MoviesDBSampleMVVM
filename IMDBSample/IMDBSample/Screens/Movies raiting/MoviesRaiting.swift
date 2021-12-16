//
//  ContentView.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import SwiftUI
import Kingfisher
struct MoviesRaiting: View {
    

    @ObservedObject private var viewModel =  MoviesRaitingviewModel(repo: IMDBHomeRepo())
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            TabView {
                List {
                    ForEach(viewModel.trending, id: \.self) { item in
                        MovieCardView(viewModel: MovieCardViewModel(model: item))
                            .animation(.default)

                    }
                }
                .tabItem { Label(
                    title: { Text("Trending") },
                    icon: { Image(systemName: "1.circle") }
                ) }
                
                
                List {
                    ForEach(viewModel.nowPlaying, id: \.self) { item in
                        MovieCardView(viewModel: MovieCardViewModel(model: item))
                            .animation(.default)

                    }
                }
                .tabItem { Label(
                    title: { Text("Now Playing") },
                    icon: { Image(systemName: "2.circle") }
                ) }
                
                List {
                    ForEach(viewModel.top, id: \.self) { item in
                        MovieCardView(viewModel: MovieCardViewModel(model: item))
                            .animation(.default)

                    }
                }
                .tabItem { Label(
                    title: { Text("Top") },
                    icon: { Image(systemName: "3.circle") }
                ) }
                
                List {
                    SearchBar(text: $viewModel.searchKeyword)
                    ForEach(viewModel.searchResults, id: \.self) { item in
                        MovieCardView(viewModel: MovieCardViewModel(model: item))
                            .animation(.default)

                    }
                }
                .tabItem { Label(
                    title: { Text("Search") },
                    icon: { Image(systemName: "magnifyingglass") }
                ) }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesRaiting()
    }
}
