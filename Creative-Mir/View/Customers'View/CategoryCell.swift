//
//  CategoryCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI

struct CategoryCell: View {
    @State var category: MWIdeaCategory = MWIdeaCategory(id: "1", categoryName: "Birthday", image: "")
    @State var isLiked = false
//    @State var numberOfIdeas: Int
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack(alignment: .topTrailing) {
                // Заглушка
                Image("avatar")
                    .resizable()
                    .scaledToFill()
//                    .frame(width: 345, height: 228)

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
            VStack(alignment: .center, spacing: 5) {
                Text(category.categoryName)
                    .font(.custom("Lora-Regular", size: 20))
                // Можно добавить количество идей
                Text("Ideas for your best \(category.categoryName.lowercased())")
                    .font(.custom("Lora-Regular", size: 15))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 40)
                Button {
                    // TODO: в зависимости от того, какую категорию пользовтель хочет сгенерировать, отображать страницу с этими идеями
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.black)
                        Text("Generate ideas")
                            .foregroundStyle(.black)
                            .font(.custom("Marcellus-Regular", size: 20))
                    }
                }
                .frame(width: 237, height: 54)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 40))
                .clipShape(RoundedRectangle(cornerRadius: 40))

            }
            .padding()

        }
        .frame(width: 360, height: 550)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}

#Preview {
    CategoryCell()
        .shadow(radius: 20)

}
