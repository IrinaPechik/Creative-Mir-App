//
//  IdeaCategoryView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 08.03.2024.
//

import SwiftUI

struct IdeaCategoryView: View {
    @StateObject var viewModel: IdeasCategoryViewModel
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.categories, id: \.id) { category in
                        CategoryCell(category: category)
                            .shadow(radius: 8)
                    }
                }
            }
        } 
        .onAppear {
            self.viewModel.getCategories()
        }
    }
}

#Preview {
    IdeaCategoryView(viewModel: IdeasCategoryViewModel())
}
