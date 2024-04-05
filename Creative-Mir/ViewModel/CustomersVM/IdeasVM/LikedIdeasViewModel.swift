//
//  LikedIdeasViewModel.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.03.2024.
//

import Foundation

class LikedIdeasViewModel: ObservableObject {
    @Published var likedIdeas: [MWIdea] = [MWIdea]()
    
    func getLikedIdeas(customerId: String, completion: @escaping (Result<[MWIdea], Error>) -> ()) {
        DatabaseService.shared.getLikedIdeas(customerId: customerId) { result in
            switch result {
            case .success(let ideas):
                self.likedIdeas = ideas
                completion(.success(ideas))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
