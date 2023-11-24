//
//  SingleView.swift
//  MovieApp
//
//  Created by Sifatul Islam on 24/11/23.
//

import UIKit
import SwiftUI
import Combine

struct SingleView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        HStack {
            HStack {
                Image(uiImage: model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                        .frame( width: 70)
                        .onAppear {
                            model.loadImage()
                        }
                
            }
            VStack {
                TitleView(title: model.title)
                    .padding(.bottom, 10)
                OverviewView(overview: model.overview)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
            return 0
        })
    }
}

struct TitleView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .frame(alignment: .leading)
            Spacer()
        }
    }
}
struct OverviewView: View {
    let overview: String
    var body: some View {
        HStack {
            Text(overview)
                .foregroundColor(Color.black.opacity(0.9))
                .font(.footnote)
                .lineLimit(100)
            Spacer()
        }
    }
}
extension SingleView {
    class Model: ObservableObject, Identifiable {
        
        var id: Int
        @Published var image: UIImage = UIImage(systemName: "photo")!
        @Published var title: String
        @Published var overview: String
        var imagePath: String
        var cancellables = Set<AnyCancellable>()
        
        init(id: Int, title: String, overview: String, imagePath: String) {
            self.id = id
            self.title = title
            self.overview = overview
            self.imagePath = imagePath
        }
        
        func loadImage() {
            HTTPClient.shared.loadImage(imagePath: imagePath)
                .receive(on: DispatchQueue.main)
                .sink { image in
                    guard let image else {return}
                    self.image = image
                }
                .store(in: &cancellables)
        }
    }
}
