//
//  StageNameInfoView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 29.02.2024.
//

import SwiftUI

struct StageNameInfoView: View {
    @State var hasStageName: Bool = false
    @State var hasNotStageName: Bool = false
    @State var stageName: String = ""

    @State private var presentNextView = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Do you have a stage name?")
                    .font(.custom("Lora-Regular", size: 28))
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading) {
                    // first toggle
                    Toggle(isOn: $hasNotStageName) {
                        Text("No")
                            .font(.custom("Marcellus-Regular", size: 20))
                            .padding()

                    }
                    .frame(width: 340, height: 61)
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(hasNotStageName ? .black : .gray, lineWidth: hasNotStageName ? 0.5 : 0.2)
                            .frame(width: 360)
                    )
                    .onChange(of: hasNotStageName) {
                        if hasNotStageName {
                            hasStageName = false
                        }
                    }
                    .padding(.bottom, 20)
                    // second toggle
                    Toggle(isOn: $hasStageName) {
                        Text("Yes")
                            .font(.custom("Marcellus-Regular", size: 20))
                            .padding()

                    }
                    .frame(width: 340, height: 61)
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(hasStageName ? .black : .gray, lineWidth: hasStageName ? 0.5 : 0.2)
                            .frame(width: 360)
                    )
                    .onChange(of: hasStageName) {
                        if hasStageName {
                            hasNotStageName = false
                        }
                    }
                    if hasStageName {
                        customTextView2(name: $stageName, placeholderName: "Stage name *")
                    }
                }
                NextButtonViewSecond(buttonText: "N E X T", isDisabled: isNextButtonDisabled()) {
                    if hasStageName {
                        AuthService.shared.saveSupplierStageName(stageName: stageName)
                    }
//                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                ProfessionalSkills()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
//            ToolbarItem(placement: .topBarTrailing) {
//                PageCounter(currentCounter: 4, allPagesCount: 7)
//            }
        }
    }
    
    func isNextButtonDisabled() -> Bool {
        if hasNotStageName {
            return false
        } else if !stageName.isEmpty && hasStageName {
            return false
        }
        return true
    }
}

#Preview {
    StageNameInfoView()
}
