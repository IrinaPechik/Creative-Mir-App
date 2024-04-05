//
//  LikedIdeas.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.03.2024.
//

import SwiftUI

struct LikedIdeas: View {
    @ObservedObject var viewModel: LikedIdeasViewModel
    
    @State private var showIdeasEmpty: Bool = true
    // Определяем структуру сетки для двух колонок
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            if showIdeasEmpty {
                Spacer()
                Text("You don't have any favorite ideas yet 😓")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                Text("Liked ideas")
                    .font(.custom("Manrope-Bold", size: 32))
                    .padding()
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 32) {
                        ForEach(viewModel.likedIdeas, id: \.id) {idea in
                            IdeaCell(viewModel: IdeasViewModel(), idea: idea)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getLikedIdeas(customerId: AuthService.shared.currentUser?.uid ?? "id") { res in
                switch res {
                case .success(_):
                    showIdeasEmpty = false
                case .failure(_):
                    showIdeasEmpty = true
                }
            }
        }
    }
}

#Preview {
    LikedIdeas(viewModel: LikedIdeasViewModel())
}
