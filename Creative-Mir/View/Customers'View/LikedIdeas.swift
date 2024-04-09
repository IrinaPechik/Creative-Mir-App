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
    @State var isLoading: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if showIdeasEmpty {
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
                                .shadow(radius: 8)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isLoading = false
            }
        }
    }
}

#Preview {
    LikedIdeas(viewModel: LikedIdeasViewModel())
}
