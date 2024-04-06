//
//  CustomerProfileEditing.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct CustomerProfileEditing: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @Binding var date: Date
    
    let startDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 14, month: 12, day: 31)) ?? Date()
    
    var body: some View {
        VStack {
            customTextView(name: $name, placeholderName: "Name")
            customTextView(name: $surname, placeholderName: "Surname")
                .padding(.top)
            DatePicker("", selection: $date, in: startDate...endDate,displayedComponents: .date)
                .scaleEffect(1.2)
                .datePickerStyle(.wheel)
                .frame(width: 100, height: 100, alignment: .center)
        }
        .padding()
    }
}

//#Preview {
//    CustomerProfileEditing()
//}
