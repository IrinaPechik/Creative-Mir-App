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
    
    func addLikeToIdea(customerId: String, idea: MWIdea) {
        DatabaseService.shared.setLikedIdeaToCustomer(customerId: customerId, idea: idea) { error in
            if error != nil {
                print("erroe while saving liked idea")
            } else {
                print("liked idea was saved")
            }
        }
    }
    
    func removeLikeFromIdea(customerId: String, idea: MWIdea) {
        DatabaseService.shared.deleteLikedIdeaToCustomer(customerId: customerId, idea: idea) { error in
            if error != nil {
                print("erroe while deleting liked idea")
            } else {
                print("liked idea was deleted")
            }
        }
    }
}
