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
    
    @Binding var presentIdeaCardView: Bool
    @Binding var chosenIdea: MWIdea?

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // Используем LazyVGrid для расположения элементов
                    LazyVGrid(columns: gridLayout, spacing: 50) {
                        ForEach(viewModel.ideas, id: \.id) { idea in
                            IdeaCell(idea: idea)
                                .shadow(radius: 8)
                                .onTapGesture {
                                    chosenIdea = idea
                                    presentIdeaCardView = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                // Получаем не все идеи, а только с нужным id
                self.viewModel.getIdeas(ideaId: chosenIdCategory)
            }
            .sheet(isPresented: $presentIdeaCardView) {
                IdeaCard(chosenIdea: $chosenIdea)
            }
        }
    }
}

#Preview {
    IdeasView(viewModel: IdeasViewModel(),
              chosenIdCategory: .constant("1"),
              presentIdeaCardView: .constant(false),
              chosenIdea: .constant(MWIdea(id: "7",
                                           categoryId: "1",
                                           name: "Pappy Pawty",
                                           description: "Description of my idea",
                                           shortDescription: "short descr",
                                           ageRestriction: 18,
                                           venuesRecommendations: "Recommendations for venues",
                                           suppliersRecommendations: "Recommendations for suppliers",
                                           peopleLimit: 100,
                                          colorScheme: "Blue")))
}


