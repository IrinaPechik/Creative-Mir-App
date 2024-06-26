//
//  RootView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: CustomerTabs = .home
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
                        .frame(height: 70)
                    if selectedPage == .generateIdeas {
                        Spacer()
                        IdeaCategoryView(viewModel: IdeasCategoryViewModel(), chosenCategoryId: $chosenIdCategory, presentNextView: $presentNextView)
                            .frame(height: 450)
                        Spacer()
                    } else if selectedPage == .exploreSuppliers {
                        Spacer()
                        ExploreSuppliersView(viewModel: ExploreSuplierViewModel())
                        Spacer()
                    } else if selectedPage == .exploreVenues {
                        Spacer()
                        ExploreVenuesView(viewModel: ExploreVenuesViewModel())
                        Spacer()
                    }
                } else if selectedTab == .likedAdvertisements {
                    LikedAdvertisementsView(viewModel: LikedAdvertisementsViewModel())
                    Spacer()
                } else if selectedTab == .likedIdeas {
                    LikedIdeas(viewModel: LikedIdeasViewModel())
                    Spacer()
                } else if selectedTab == .profile {
                    CustomerProfileView()
                    Spacer()
                } else if selectedTab == .bookings {
                    CustomerBookingView(bookingViewModel: CustomerBookViewModel())
                    Spacer()
                }
                
                CustomerTabBar(selectedTab: $selectedTab)
            }
            .sheet(isPresented: $presentNextView) {
                IdeasView(viewModel: IdeasViewModel(), chosenIdCategory: $chosenIdCategory)
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                customBackButton()
//            }
//        }
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

//#Preview {
//    CustomerProfileView()
//}
