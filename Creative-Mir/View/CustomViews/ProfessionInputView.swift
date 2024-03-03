//
//  ExperienceInputView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 01.03.2024.
//

import SwiftUI

enum Experience: String, CaseIterable, Identifiable {
    case years
    case months
    case days
    
    var id: Self {
        self
    }
}

enum SupplierProfession: String, CaseIterable, Identifiable {
    case Сaterer
    case Florist
    case Photographer
    case Videographer
    case DJ
    case Musician
    case Decorator
    case noneValue = ""
    
    static var visibleCases: [SupplierProfession] {
        return SupplierProfession.allCases.filter {
            $0 != .noneValue
        }
    }

    var id: Self {
        self
    }
}

struct ProfessionChoosingView: View {
    @Binding var supplierProfession: SupplierProfession
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Choose your profession")
                .font(.custom("Marcellus-Regular", size: 15))
            Menu {
                Picker(selection: $supplierProfession, label: Text("")) {
                    ForEach(SupplierProfession.visibleCases, id: \.self) { profession in
                        Text(profession.rawValue).tag(profession)
                    }
                }
            } label: {
                HStack() {
                    Text("\(supplierProfession.rawValue)")
                        .foregroundStyle(.black)
                        .font(.custom("Lora-Regular", size: 19))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                        .scaleEffect(0.8)
                }
                .frame(width: 293, height: 40) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
            }
        }
        .padding()
    }
}

struct ExperienceInputView: View {
    @Binding var selectedNumber: Int
    @Binding var selectedUnit: Experience

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Work experience")
                .font(.custom("Marcellus-Regular", size: 15))
            HStack(spacing: 30) {
                Menu {
                    Picker(selection: $selectedNumber, label: Text("")) {
                        ForEach(0...30, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                } label: {
                    HStack() {
                        Text("\(selectedNumber)")
                            .foregroundStyle(.black)
                            .font(.custom("Lora-Regular", size: 19))
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.black)
                            .scaleEffect(0.7)
                    }
                    .frame(height:35)
                }
                Menu {
                    Picker(selection: $selectedUnit, label: Text("")) {
                        ForEach(Experience.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    
                } label: {
                    HStack {
                        Text(selectedUnit.rawValue)
                            .foregroundStyle(.black)
                            .font(.custom("Lora-Regular", size: 19))
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.black)
                            .scaleEffect(0.7)
                    }
                    .frame(height:35)
                }
            }
            .overlay(
                Rectangle().frame(width: 290, height: 1),
                alignment: .bottomLeading) // Нижняя линия
            .foregroundColor(.black) // Цвет текста
        }
        .padding()
    }
}

//#Preview {
//    ExperienceInputView()
//}
