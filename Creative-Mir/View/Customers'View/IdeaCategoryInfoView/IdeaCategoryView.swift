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
                        .font(.custom("Manrope-Bold", size: 32))
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewModel.categories, id: \.id) { category in
                                CategoryCell(category: category, chosenCategoryId: $chosenCategoryId, presentNextView: $presentNextView)
                                    .padding()
                                    .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .frame(height: 600)
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
