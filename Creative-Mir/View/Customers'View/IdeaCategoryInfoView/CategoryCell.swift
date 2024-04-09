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
                    .frame(height: 348)
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            VStack(alignment: .center, spacing: 5) {
                Text("\(category.categoryName) party")
                    .font(.custom("PlayfairDisplay-Medium", size: 38))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                // TODO: Можно добавить количество идей
                Text("Ideas for your best \(category.categoryName.lowercased())")
                    .font(.custom("FuturaPT-Light", size: 23))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 40)
                Spacer()

                Button {
                    // В зависимости от того, какую категорию пользователь хочет сгенерировать, отображать страницу с этими идеями
                    chosenCategoryId = category.id
                    presentNextView = true
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.black)
                        Text("G E N E R A T E")
                            .foregroundStyle(.black)
                            .font(.custom("PlayfairDisplay-Medium", size: 20))
                    }
                }
                .frame(width: 237, height: 54)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 0.4))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                Spacer()
            }
            .padding()
        }
        .frame(width: 350, height: 580)
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
        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
}
