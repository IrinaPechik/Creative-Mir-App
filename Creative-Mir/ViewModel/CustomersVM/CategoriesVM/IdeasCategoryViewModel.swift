//
//  IdeasCategoryViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 08.03.2024.
//
import Foundation

class IdeasCategoryViewModel: ObservableObject {
    @Published var categories: [MWIdeaCategory] = [MWIdeaCategory]()

    func getCategories() {
        DatabaseService.shared.getIdeaCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
