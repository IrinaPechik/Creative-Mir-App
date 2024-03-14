//
//  CategoryCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 09.03.2024.
//

import SwiftUI

struct CategoryCell: View {
    @State var category: MWIdeaCategory = MWIdeaCategory(id: "1", categoryName: "Birthday")
    @Binding var chosenCategoryId: String
    @Binding var presentNextView: Bool

    @State var uiImage: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            if uiImage == nil {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(height: 250)
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .padding(.bottom, 99)
            }
            VStack(alignment: .center, spacing: 5) {
                Text("\(category.categoryName) party")
                    .font(.custom("Lora-Regular", size: 32))
                // TODO: Можно добавить количество идей
                Text("Ideas for your best \(category.categoryName.lowercased())")
                    .font(.custom("FuturaPT-Light", size: 20))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 40)
                Button {
                    // В зависимости от того, какую категорию пользователь хочет сгенерировать, отображать страницу с этими идеями
                    chosenCategoryId = category.id
                    presentNextView = true
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.black)
                        Text("generate ideas")
                            .foregroundStyle(.black)
                            .font(.custom("PlayfairDisplay-Medium", size: 20))
                    }
                }
                .frame(width: 237, height: 54)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 0.4))
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
            .padding()

        }
        .frame(width: 360, height: 459)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            StorageService.shared.downloadCategoryImage(id: self.category.id) { result in
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
    CategoryCell(chosenCategoryId: .constant("1"), presentNextView: .constant(false))
        .shadow(radius: 20)

}
