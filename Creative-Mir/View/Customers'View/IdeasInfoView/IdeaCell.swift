//
//  IdeaCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct IdeaCell: View {
    @StateObject var viewModel: IdeasViewModel

    @State var idea: MWIdea
    
    @State var isLiked = false
    @State var uiImage: UIImage? = nil
    
    @State var presentIdeaCardView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                if uiImage == nil {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: 172, height: 150)
                } else {
                    Image(uiImage: uiImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 172, height: 150)
                        .padding(.bottom, 10)
                }

                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(isLiked ? .red : .white)
                    .padding(10)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isLiked.toggle()
                        }
                        if isLiked {
                            viewModel.addLikeToIdea(customerId: AuthService.shared.currentUser?.uid ?? "id", idea: self.idea)
                        } else {
                            viewModel.removeLikeFromIdea(customerId: AuthService.shared.currentUser?.uid ?? "id", idea: self.idea)
                        }
                    }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(idea.name)
                    .font(.custom("Lora-Regular", size: 20))

                Text(idea.shortDescription)
                    .font(.custom("Lora-Regular", size: 15))
                    .foregroundStyle(.gray)
            }
            .padding()
        }
        .frame(width: 172, height: 269)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            presentIdeaCardView = true
        }
        .sheet(isPresented: $presentIdeaCardView) {
            IdeaCard(viewModel: IdeasViewModel(), chosenIdea: $idea, isLiked: $isLiked)
        }
        .onAppear {
            StorageService.shared.downloadIdeaImage(id: self.idea.id) {result in
                switch result {
                case .success(let data):
                    if let img = UIImage(data: data) {
                        self.uiImage = img
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.checkWasIdeaLikedById(customerId: AuthService.shared.currentUser?.uid ?? "id", ideaId: idea.id) { res in
                switch res {
                case .success(let wasLiked):
                    isLiked = wasLiked
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    IdeaCell(viewModel: IdeasViewModel(), idea: MWIdea(id: "7", categoryId: "1",
                          name: "Pappy Pawty",
                         description: "Description of my idea",
                         shortDescription: "short descr",
                          ageRestriction: 18,
                          venuesRecommendations: "Recommendations for venues",
                          suppliersRecommendations: "Recommendations for suppliers",
                          peopleLimit: 100,
                          colorScheme: "Blue"))
        .shadow(radius: 20)

}
