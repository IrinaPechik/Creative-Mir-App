//
//  ExploreSuppliersView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 14.03.2024.
//

import SwiftUI

struct ExploreSuppliersView: View {
    @StateObject var viewModel: ExploreSuplierViewModel
    @State private var showEmptyError: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            if showEmptyError {
                Text("There are no registered suppliers yet 😓")
                    .font(.custom("Manrope-Bold", size: 27))
                    .frame(width: 320)
            } else {
                Text("Explore Suppliers")
                    .font(.custom("Manrope-Bold", size: 32))
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(viewModel.suppliers, id: \.id) { supplier in
                            ForEach(supplier.advertisements.indices, id: \.self) { advInd in
                                SupplierCell(viewModel: ExploreSuplierViewModel(), supplier: supplier, advIndex: advInd)
                            }
                        }
                    }
                    .frame(width: 390)
                }
                .frame(width: 390)
            }
        }
        .onAppear {
            self.viewModel.getSuppliers() { res in
                switch res {
                case .success(_):
                    showEmptyError = false
                case .failure(_):
                    showEmptyError = true
                }
            }
        }
    }
}

#Preview {
    ExploreSuppliersView(viewModel: ExploreSuplierViewModel())
}
