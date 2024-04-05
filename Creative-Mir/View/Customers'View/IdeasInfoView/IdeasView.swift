//
//  IdeasView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct IdeasView: View {
    @StateObject var viewModel: IdeasViewModel
    // Определяем структуру сетки для двух колонок
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)
    @Binding var chosenIdCategory: String

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // Используем LazyVGrid для расположения элементов
                    LazyVGrid(columns: gridLayout, spacing: 50) {
                        ForEach(viewModel.ideas, id: \.id) { idea in
                            IdeaCell(viewModel: IdeasViewModel(), idea: idea)
                                .shadow(radius: 8)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                // Получаем не все идеи, а только с нужным id
                self.viewModel.getIdeas(ideaId: chosenIdCategory)
            }
        }
    }
}

#Preview {
    IdeasView(viewModel:  IdeasViewModel(),
              chosenIdCategory: .constant("1"))
}


