//
//  IdeasViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 08.03.2024.
//

import Foundation

class IdeasViewModel: ObservableObject {
    @Published var ideas: [MWIdea] = [MWIdea]()
    
    func getIdeas(ideaId: String) {
        DatabaseService.shared.getIdeas(by: ideaId) { result in
            switch result {
            case .success(let ideas):
                self.ideas = ideas
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
