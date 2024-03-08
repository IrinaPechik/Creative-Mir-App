//
//  IdeasView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct IdeasView: View {
    @StateObject var viewModel: IdeasViewModel
//        @State private var selectedEventCategory: EventTypes = .animalsBirthday

    // Определяем структуру сетки для двух колонок
    var gridLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: 15), count: 2)

    
    var body: some View {
        NavigationView {
            ScrollView {
                // Используем LazyVGrid для расположения элементов
                LazyVGrid(columns: gridLayout, spacing: 50) {
                    ForEach(viewModel.ideas, id: \.id) { idea in
                        IdeaCell(idea: idea)
                            .shadow(radius: 8)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            self.viewModel.getIdeas()
        }
    }
}

#Preview {
    IdeasView(viewModel: IdeasViewModel())
}


