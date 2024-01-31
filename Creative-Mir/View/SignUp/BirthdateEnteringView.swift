//
//  BirthdateEnteringView.swift
//  Creative-Mir
//
//  Created by Печик Дарья on 31.01.2024.
//

import SwiftUI

struct BirthdateEnteringView: View {
//    @State private var date: Int = 0
//    @State private var month: Int = 0
//    @State private var year: Int = 0
    @State private var date: Date = Date.now

    @State private var surname: String = ""
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 40) {
                Text("Enter your birthdate")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding()
                VStack {
                    BirthdateView(date: $date)
                }
                .padding()
                NextButtonViewSecond(isDisabled: false) {
                    print(date)
                    // Переход к следующей view
                }
                .padding(.top, 100)
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 3)
            }
        }
    }
}

#Preview {
    BirthdateEnteringView()
}

struct BirthdateView: View {
    @Binding var date: Date
    
    let startDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 31)) ?? Date()

    var body: some View {
        VStack() {
            DatePicker("", selection: $date, in: startDate...endDate,displayedComponents: .date)
                .font(.custom("PlayfairDisplay-Medium", size: 48))
                .datePickerStyle(.wheel)
                .frame(width: 100, height: 100)
        }
    }
}