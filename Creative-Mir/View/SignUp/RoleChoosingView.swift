//
//  RoleChoosingView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 17.01.2024.
//

import SwiftUI

enum UserRoles: String, Codable {
    case customer = "I want to organise my event"
    case supplier = "I am a supplier"
    case venue = "I am a venue"
}
struct RoleChoosingView: View {
    @State private var selectedStatus: Int = 1
    
    @State private var presentNextView = false
    @State private var nextView: UserRoles = .customer
    
    let statusOptions = [UserRoles.customer, UserRoles.supplier, UserRoles.venue]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Who are you?")
                    .font(.custom("PlayfairDisplay-Medium", size: 48))
                    .padding(.bottom, 180)
                Picker("Who are you?", selection: $selectedStatus) {
                    ForEach(0 ..< statusOptions.count) {
                        Text(statusOptions[$0].rawValue)
                            .font(.custom("Lora-Regular", size: 18))
                    }
                }
                .padding(.top, -150)
                .scaleEffect(1.5)
                .pickerStyle(.wheel)
                
                NextButtonView(isDisabled: false) {
                    AuthService.shared.saveUserRole(role: String(describing: statusOptions[selectedStatus]))
                    presentNextView.toggle()
                }
            }.navigationDestination(isPresented: $presentNextView) {
                NameEnteringView()
            }
        }
    }
}


#Preview {
    RoleChoosingView()
}
