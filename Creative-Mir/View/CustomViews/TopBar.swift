//
//  TopBar.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

enum TopBars: Int {
    case generateIdeas = 0
    case exploreSuppliers = 1
    case exploreVenues = 2
}

struct TopBar: View {
    @Binding var selectedTopBar: TopBars
    var body: some View {
            LazyHStack {
                Button {
                    selectedTopBar = .generateIdeas
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                        VStack(alignment: .leading) {
                            Text("Generate")
                                .font(.custom("Lora-Regular", size: 15))
                            Text("ideas")
                                .font(.custom("Lora-Regular", size: 15))
                        }
                    }
                    .padding()
                    .frame(width: 124, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(selectedTopBar == .generateIdeas ? .black : .gray)
                    )
                    .foregroundColor(selectedTopBar == .generateIdeas ? .black : .gray)
                    .cornerRadius(40)
                }
                
                
                Button {
                    selectedTopBar = .exploreSuppliers
                } label: {
                    HStack {
                        Image(systemName: "music.mic")
                        VStack(alignment: .leading) {
                            Text("Explore")
                                .font(.custom("Lora-Regular", size: 15))
                            Text("suppliers")
                                .font(.custom("Lora-Regular", size: 15))
                        }
                    }
                    .padding()
                    .frame(width: 125, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(selectedTopBar == .exploreSuppliers ? .black : .gray)
                    )
                    .foregroundColor(selectedTopBar == .exploreSuppliers ? .black : .gray)
                    .cornerRadius(40)
                }
                
                Button {
                    selectedTopBar = .exploreVenues
                } label: {
                    HStack {
                        Image(systemName: "building.2")
                        VStack(alignment: .leading) {
                            Text("Explore")
                                .font(.custom("Lora-Regular", size: 15))
                            Text("venues")
                                .font(.custom("Lora-Regular", size: 15))
                        }
                    }
                    .padding()
                    .frame(width: 118, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(selectedTopBar == .exploreVenues ? .black : .gray)
                    )
                    .foregroundColor(selectedTopBar == .exploreVenues ? .black : .gray)
                    .cornerRadius(40)
                }
            }
            .padding()
    }
}

#Preview {
    TopBar(selectedTopBar: .constant(TopBars.generateIdeas))
}
