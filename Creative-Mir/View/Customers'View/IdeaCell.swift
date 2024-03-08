//
//  IdeaCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct IdeaCell: View {
    @State var idea: MWIdea = MWIdea(id: "1",
                                      name: "Pappy Pawty",
                                      image: "jj",
                                     description: "Description of my idea",
                                     shortDescription: "short descr",
                                      eventType: "Some Event",
                                      ageRestriction: 18,
                                      venuesRecommendations: "Recommendations for venues",
                                      suppliersRecommendations: "Recommendations for suppliers",
                                      peopleLimit: 100,
                                      colorScheme: "Blue")
    @State var isLiked = false
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // Заглушка
                Image("avatar")
                    .resizable()
                    .scaledToFit()
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(isLiked ? .red : .white)
                    .padding()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isLiked.toggle()
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
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}

#Preview {
    IdeaCell()
        .shadow(radius: 20)

}
