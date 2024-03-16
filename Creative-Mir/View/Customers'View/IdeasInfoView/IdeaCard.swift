//
//  IdeaCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 13.03.2024.
//

import SwiftUI

struct IdeaCard: View {
    @Binding var chosenIdea: MWIdea?
    @State var uiImage: UIImage? = nil
    @State var isLiked = false
    @State var color: UIColor = .gray
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let uiImage = uiImage, let chosenIdea = chosenIdea {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .padding()
                            .foregroundColor(isLiked ? .red : .white)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isLiked.toggle()
                                }
                            }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 350, height: 350)
                    Text(chosenIdea.name)
                        .font(.custom("PlayfairDisplay-Medium", size: 40))
                    Text(chosenIdea.shortDescription)
                        .font(.custom("Lora-Regular", size: 20))
                    Spacer(minLength: 30)
                    VStack(alignment: .center) {
                        VStack (alignment: .leading) {
                            HStack(alignment: .center, spacing: 20) {
                                Text("Color scheme:")
                                    .font(.custom("Lora-Regular", size: 20))
                                Text("\(chosenIdea.colorScheme.lowercased())")
                                    .font(.custom("Lora-Regular", size: 18))
                            }
                            Spacer(minLength: 20)
                            HStack(alignment: .center, spacing: 20) {
                                Text("Recommended age:")
                                    .font(.custom("Lora-Regular", size: 20))
                                Text("\(chosenIdea.ageRestriction) +")
                                    .font(.custom("Lora-Regular", size: 18))
                            }
                            Spacer(minLength: 20)
                            
                            HStack(alignment: .center, spacing: 20) {
                                Text("Recommended places:")
                                    .font(.custom("Lora-Regular", size: 20))
                                Text("\(chosenIdea.venuesRecommendations)")
                                    .font(.custom("Lora-Regular", size: 18))
                            }
                            Spacer(minLength: 20)
                            
                            HStack(alignment: .center, spacing: 20) {
                                Text("Recommended suppliers:")
                                    .font(.custom("Lora-Regular", size: 20))
                                Text("\(chosenIdea.suppliersRecommendations)")
                                    .font(.custom("Lora-Regular", size: 18))
                            }
                            Spacer(minLength: 30)
                            
                            Text(chosenIdea.description)
                                .font(.custom("FuturaPT-Light", size: 20))
                                .frame(width: 350)
                                .padding(.top, 10)
                        }
                        .padding()
                    }
                } else {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: 172, height: 870)
                }
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            StorageService.shared.downloadIdeaImage(id: self.chosenIdea!.id) {result in
                switch result {
                case .success(let data):
                    if let img = UIImage(data: data) {
                        self.uiImage = img
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    IdeaCard(chosenIdea: .constant(MWIdea(id: "7",
                                    categoryId: "4",
                                    name: "Puppy Pawty",
                                    description: "Get ready to wag your tails and bark with delight at the \"Puppy Pawty\" – the ultimate celebration for our furry friends! Picture a whimsically decorated venue adorned paw-print banners, and doggy-themed decorations. Pups of all shapes and sizes prance around, sporting adorable party hats and wagging their tails with excitement. From a doggy fashion show showcasing the latest canine couture to a playful game of fetch and a \"best trick\" competition, there's no shortage of tail-wagging fun. As their humans mingle and share stories, four-legged guests indulge in delicious treats like pup-friendly birthday cake and refreshing bowls of water. With every woof and wiggle, it's evident that this Puppy Pawty is a barking success, leaving paw prints of joy on the hearts of all who attend.",
                                    shortDescription: "Unless the fun",
                                    ageRestriction: 0,
                                    venuesRecommendations: "Verve dog boutique",
                                    suppliersRecommendations: "merimeri",
                                    peopleLimit: 20,
                                    colorScheme: "Green")))
}
