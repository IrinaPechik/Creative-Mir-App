//
//  IdeaCategoryView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 08.03.2024.
//

import SwiftUI

struct IdeaCategoryView: View {
    @StateObject var viewModel: IdeasCategoryViewModel
    @Binding var chosenCategoryId: String
    @Binding var presentNextView: Bool
    var body: some View {
            VStack(spacing: 20) {
                if viewModel.categories.isEmpty {
                    ProgressView()
                        .scaleEffect(2.0)
                } else {
                    Text("Choose event category")
                        .font(.custom("Lora-Regular", size: 34))
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewModel.categories, id: \.id) { category in
                                CategoryCell(category: category, chosenCategoryId: $chosenCategoryId, presentNextView: $presentNextView)
                                    .shadow(radius: 8)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(height: 500)
                }
            }
        .onAppear {
            self.viewModel.getCategories()
        }
    }
}

#Preview {
    IdeaCategoryView(viewModel: IdeasCategoryViewModel(), chosenCategoryId: .constant("1"), presentNextView: .constant(false))
}
