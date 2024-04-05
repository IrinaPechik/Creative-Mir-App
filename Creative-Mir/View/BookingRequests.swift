//
//  BookingRequests.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

struct BookingRequests: View {
    @StateObject var viewModel: BookingRequestsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.allRequestsForBooking, id: \.id) {request in
                    Text("\(request.customerMessage)")
                }
            }
        }
        .onAppear {
            viewModel.getAllRequests(id: AuthService.shared.getUserId())
        }
    }
    
}

#Preview {
    BookingRequests(viewModel: BookingRequestsViewModel())
}
