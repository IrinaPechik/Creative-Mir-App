//
//  RootView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .home
    @State private var selectedPage: TopBars = .generateIdeas
    
    @State private var presentNextView: Bool = false
    @State var chosenIdCategory: String = ""
    
    @State var presentIdeaCardView: Bool = false
    @State var chosenIdea: MWIdea? = nil
    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == .home {
                    TopBar(selectedTopBar: $selectedPage)
                        .frame(height: 80)
                    if selectedPage == .generateIdeas {
                        Spacer()
                        IdeaCategoryView(viewModel: IdeasCategoryViewModel(), chosenCategoryId: $chosenIdCategory, presentNextView: $presentNextView)
                            .frame(height: 450)
                        Spacer()
                    } else if selectedPage == .exploreSuppliers {
                        Spacer()
                        Text("ideas")
                        Spacer()
                    } else if selectedPage == .exploreVenues {
                        Spacer()
                        Text("ideas")
                        Spacer()
                    }
                } else if selectedTab == .star {
                    StarView()
                } else if selectedTab == .message {
                    MessageView()
                } else if selectedTab == .profile {
                    CustomerProfileView()
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .sheet(isPresented: $presentNextView) {
                IdeasView(viewModel: IdeasViewModel(), chosenIdCategory: $chosenIdCategory, presentIdeaCardView: $presentIdeaCardView, chosenIdea: $chosenIdea)
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
        }
    }
}


struct MessageView: View {
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Text("Message Tab")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

struct StarView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            Text("Star Tab")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    CustomerProfileView()
}
