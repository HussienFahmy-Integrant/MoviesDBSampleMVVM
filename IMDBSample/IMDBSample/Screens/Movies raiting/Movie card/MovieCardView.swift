//
//  MovieCard.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import SwiftUI
import Kingfisher

struct ImageOverlay: View {
    @State private var shouldReload = false
    private var caption = ""
    var body: some View {
        ZStack {
            Text(caption)
                .font(.title2)
                .padding(6)
                .foregroundColor(.black)
        }.background(Color.white)
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
    
    init(caption: String) {
        self.caption = caption
        shouldReload.toggle()
    }
}

struct MovieCardView: View {
    @ObservedObject private var viewModel: MovieCardViewModel
    var body: some View {
        KFImage(viewModel.posterURL)
            .resizable()
            .scaledToFit()
            .overlay(ImageOverlay(caption: viewModel.movieTitle ), alignment: .bottomTrailing)
            .cornerRadius(4)
            .shadow(radius: 4)
            .padding()
    }
    init(viewModel: MovieCardViewModel) {
        self.viewModel = viewModel
    }
}
