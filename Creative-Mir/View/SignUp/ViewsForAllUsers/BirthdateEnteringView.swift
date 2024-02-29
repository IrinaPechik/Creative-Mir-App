//
//  BirthdateEnteringView.swift
//  Creative-Mir
//
//  Created by Печик Дарья on 31.01.2024.
//

import SwiftUI

struct BirthdateEnteringView: View {
    @State private var date: Date = Date.now

    @State private var surname: String = ""
    @State private var presentNextView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 40) {
                Text("Enter your birthdate")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding(.bottom, 70)
                BirthdateView(date: $date)
                NextButtonViewSecond(buttonText: "N E X T",isDisabled: false) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    print(dateFormatter.string(from: date))
                    AuthService.shared.saveUserBirthDateStr(birthDateStr: dateFormatter.string(from: date))
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                AdressSelectionView()
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 3, allPagesCount: 5)
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
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) - 14, month: 12, day: 31)) ?? Date()

    var body: some View {
        DatePicker("", selection: $date, in: startDate...endDate,displayedComponents: .date)
            .scaleEffect(1.2)
            .datePickerStyle(.wheel)
            .frame(width: 100, height: 100, alignment: .center)
    }
}
